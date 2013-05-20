require_relative 'ski_call'
require_relative 'ski_symbol'

class SKICombinator < SKISymbol
  def as_a_function_of(name)
    SKICall.new(K, self)
  end
end
