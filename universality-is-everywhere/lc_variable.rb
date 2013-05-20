require_relative '../programming-with-nothing/lc_variable'
require_relative 'ski_symbol'

class LCVariable
  def to_ski
    SKISymbol.new(name)
  end
end
