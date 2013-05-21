require_relative '../../programming_with_nothing/lambda_calculus/lc_variable'
require_relative 'ski_symbol'

class LCVariable
  def to_ski
    SKISymbol.new(name)
  end
end
