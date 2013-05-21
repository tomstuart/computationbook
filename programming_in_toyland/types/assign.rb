require_relative '../../the_meaning_of_programs/syntax/assign'
require_relative 'type'

class Assign
  def type(context)
    if context[name] == expression.type(context)
      Type::VOID
    end
  end
end
