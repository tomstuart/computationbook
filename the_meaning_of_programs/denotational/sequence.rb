require_relative '../syntax/sequence'

class Sequence
  def to_ruby
    "-> e { (#{second.to_ruby}).call((#{first.to_ruby}).call(e)) }"
  end

  def to_javascript
    "function (e) { return (#{second.to_javascript}(#{first.to_javascript}(e))); }"
  end
end
