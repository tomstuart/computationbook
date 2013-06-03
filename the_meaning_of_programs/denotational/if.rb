require_relative '../syntax/if'

class If
  def to_ruby
    "-> e { if (#{condition.to_ruby}).call(e)" +
      " then (#{consequence.to_ruby}).call(e)" +
      " else (#{alternative.to_ruby}).call(e)" +
      " end }"
  end

  def to_javascript
    "function (e) { if (#{condition.to_javascript}(e))" +
      " { return (#{consequence.to_javascript}(e)); }" +
      " else { return (#{alternative.to_javascript}(e)); }" +
      " }"
  end
end
