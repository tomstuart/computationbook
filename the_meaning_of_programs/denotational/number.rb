require_relative '../syntax/number'

class Number
  def to_ruby
    "-> e { #{value.inspect} }"
  end
end
