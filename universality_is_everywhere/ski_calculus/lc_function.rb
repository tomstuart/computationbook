require_relative '../../programming_with_nothing/lambda_calculus/lc_function'

class LCFunction
  def to_ski
    body.to_ski.as_a_function_of(parameter)
  end
end
