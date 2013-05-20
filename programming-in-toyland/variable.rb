require_relative '../the-meaning-of-programs/variable'

class Variable
  def type(context)
    context[name]
  end
end
