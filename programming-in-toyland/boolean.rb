require_relative '../the-meaning-of-programs/boolean'
require_relative 'type'

class Boolean
  def type(context)
    Type::BOOLEAN
  end
end
