require_relative '../the-meaning-of-programs/number'
require_relative 'type'

class Number
  def type(context)
    Type::NUMBER
  end
end
