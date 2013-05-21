require_relative '../syntax/while'
require_relative 'do_nothing'
require_relative 'if'
require_relative 'sequence'

class While
  def reducible?
    true
  end

  def reduce(environment)
    [If.new(condition, Sequence.new(body, self), DoNothing.new), environment]
  end
end
