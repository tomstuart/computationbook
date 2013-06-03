require_relative '../syntax/multiply'

class Multiply
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}).call(e) }"
  end

  def to_javascript
    "function (e) { return (#{left.to_javascript}(e)) * (#{right.to_javascript}(e)); }"
  end
end
