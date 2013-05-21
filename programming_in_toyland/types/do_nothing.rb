require_relative '../../the_meaning_of_programs/do_nothing'
require_relative 'type'

class DoNothing
  def type(context)
    Type::VOID
  end
end
