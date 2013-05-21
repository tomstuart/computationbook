require_relative '../../the_meaning_of_programs/syntax/while'
require_relative 'type'

class While
  def type(context)
    if condition.type(context) == Type::BOOLEAN && body.type(context) == Type::VOID
      Type::VOID
    end
  end
end
