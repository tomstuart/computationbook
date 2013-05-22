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
    subject.to_ruby
  end

  failure_message_for_should do |subject|
    "expected that #{subject.inspect} would be denoted by #{expected.inspect}, but it is denoted by #{actual(subject).inspect}"
  end
end

RSpec::Matchers.define :mean do |expected|
  match do |subject|
    actual(subject) == expected
  end

  def actual(subject)
    eval(subject.to_ruby)[environment]
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
