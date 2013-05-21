require_relative '../syntax/add'
require_relative 'number'

class Add
  def evaluate(environment)
    Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
  end
end
