require_relative '../syntax/multiply'
require_relative 'number'

class Multiply
  def evaluate(environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end
