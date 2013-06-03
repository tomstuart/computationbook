require 'execjs/json'
require_relative '../syntax/boolean'

class Boolean
  def to_ruby
    "-> e { #{value.inspect} }"
  end

  def to_javascript
    "function (e) { return #{ExecJS::JSON.encode(value)}; }"
  end
end
