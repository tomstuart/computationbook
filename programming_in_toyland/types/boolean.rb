require_relative '../../the_meaning_of_programs/syntax/boolean'
require_relative 'type'

class Boolean
  def type(context)
    Type::BOOLEAN
  end
end
