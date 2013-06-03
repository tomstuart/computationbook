require_relative '../syntax/less_than'

class LessThan
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}).call(e) }"
  end

  def to_javascript
    "function (e) { return (#{left.to_javascript}(e)) < (#{right.to_javascript}(e)); }"
  end
end
