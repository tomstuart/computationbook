require_relative '../programming_with_nothing/lc_variable'
require_relative 'ski_symbol'

class LCVariable
  def to_ski
    SKISymbol.new(name)
  end
end
