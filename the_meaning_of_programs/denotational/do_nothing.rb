require_relative '../syntax/do_nothing'

class DoNothing
  def to_ruby
    '-> e { e }'
  end
end
