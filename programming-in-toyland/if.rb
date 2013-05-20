require_relative '../the-meaning-of-programs/if'
require_relative 'type'

class If
  def type(context)
    if condition.type(context) == Type::BOOLEAN &&
      consequence.type(context) == Type::VOID &&
      alternative.type(context) == Type::VOID
      Type::VOID
    end
  end
end
