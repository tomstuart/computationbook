require_relative '../../the_meaning_of_programs/syntax/less_than'
require_relative 'type'

class LessThan
  def type(context)
    if left.type(context) == Type::NUMBER && right.type(context) == Type::NUMBER
      Type::BOOLEAN
    end
  end
end
