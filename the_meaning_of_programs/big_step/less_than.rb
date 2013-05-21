require_relative '../syntax/less_than'
require_relative 'boolean'

class LessThan
  def evaluate(environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
end
