require_relative '../../the_meaning_of_programs/syntax/add'
require_relative 'type'

class Add
  def type(context)
    if left.type(context) == Type::NUMBER && right.type(context) == Type::NUMBER
      Type::NUMBER
    end
  end
end
