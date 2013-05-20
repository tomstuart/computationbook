require_relative '../the-meaning-of-programs/while'
require_relative 'type'

class While
  def type(context)
    if condition.type(context) == Type::BOOLEAN && body.type(context) == Type::VOID
      Type::VOID
    end
  end
end
