require_relative '../../the_meaning_of_programs/variable'

class Variable
  def type(context)
    context[name]
  end
end
