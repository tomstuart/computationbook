require_relative '../programming_with_nothing/lc_function'

class LCFunction
  def to_ski
    body.to_ski.as_a_function_of(parameter)
  end
end
