require_relative '../../the_meaning_of_programs/syntax/sequence'
require_relative 'type'

class Sequence
  def type(context)
    if first.type(context) == Type::VOID && second.type(context) == Type::VOID
      Type::VOID
    end
  end
end
