require 'execjs'

RSpec::Matchers.define :look_like do |expected|
  match do |subject|
    actual(subject) == expected
  end

  def actual(subject)
    subject.to_s
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would look like #{expected.inspect}, but it looks like #{actual(subject).inspect}"
  end
end

RSpec::Matchers.define :reduce_to do |expected|
  match do |subject|
    actual(subject) == expected
  end

  def actual(subject)
    subject.reduce(environment)
  end

  def environment
    @environment || {}
  end

  chain :within do |environment|
    @environment = environment
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would reduce to #{expected.inspect} within #{environment.inspect}, but it reduces to #{actual(subject).inspect}"
  end
end

RSpec::Matchers.define :evaluate_to do |expected|
  match do |subject|
    actual(subject) == expected
  end

  def actual(subject)
    subject.evaluate(environment)
  end

  def environment
    @environment || {}
  end

  chain :within do |environment|
    @environment = environment
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would evaluate to #{expected.inspect} within #{environment.inspect}, but it evaluates to #{actual(subject).inspect}"
  end
end

RSpec::Matchers.define :be_denoted_by do |expected|
  match do |subject|
    actual(subject) == expected
  end

  def actual(subject)
    subject.send(:"to_#{denotation_language}")
  end

  def denotation_language
    example.metadata[:in] || :ruby
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would be denoted by #{expected.inspect}, but it is denoted by #{actual(subject).inspect}"
  end
end

RSpec::Matchers.define :mean do |expected|
  match do |subject|
    actual(subject) == expected_for_denotation_language(expected)
  end

  def actual(subject)
    case denotation_language
    when :ruby
      eval(subject.to_ruby)[environment]
    when :javascript
      ExecJS.eval("#{subject.to_javascript}(#{ExecJS::JSON.encode(environment)})")
    end
  end

  def environment
    @environment || {}
  end

  def denotation_language
    example.metadata[:in] || :ruby
  end

  def expected_for_denotation_language(expected)
    case denotation_language
    when :ruby
      expected
    when :javascript
      ExecJS::JSON.decode(ExecJS::JSON.encode(expected))
    end
  end

  chain :within do |environment|
    @environment = environment
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would reduce to #{expected_for_denotation_language(expected).inspect} within #{environment.inspect}, but it reduces to #{actual(subject).inspect}"
  end
end

RSpec::Matchers.define :parse_as do |expected|
  match do |subject|
    actual(subject) == expected
  end

  def actual(subject)
    parse_tree = parse(subject)
    parse_tree.to_ast unless parse_tree.nil?
  end

  def parse(string)
    parser = SimpleParser.new
    [:statement, :expression].map { |root| parser.parse(string, root: root) rescue nil }.compact.first
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would parse as #{expected.inspect}, but it parses as #{actual(subject).inspect}"
  end
end
