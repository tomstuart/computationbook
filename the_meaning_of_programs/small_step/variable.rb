require_relative '../syntax/variable'

class Variable
  def reducible?
    true
  end

  def reduce(environment)
    environment[name]
  end
end
