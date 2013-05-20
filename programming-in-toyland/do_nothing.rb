require_relative '../the-meaning-of-programs/do_nothing'
require_relative 'type'

class DoNothing
  def type(context)
    Type::VOID
  end
end
