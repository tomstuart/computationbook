require_relative '../../the_meaning_of_programs/syntax/variable'

class Variable
  def type(context)
    context[name]
  end
end
