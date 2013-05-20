require_relative '../the-meaning-of-programs/add'
require_relative 'type'

class Add
  def type(context)
    if left.type(context) == Type::NUMBER && right.type(context) == Type::NUMBER
      Type::NUMBER
    end
  end
end
