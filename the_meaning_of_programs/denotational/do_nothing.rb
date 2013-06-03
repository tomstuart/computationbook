require_relative '../syntax/do_nothing'

class DoNothing
  def to_ruby
    '-> e { e }'
  end

  def to_javascript
    'function (e) { return e; }'
  end
end
