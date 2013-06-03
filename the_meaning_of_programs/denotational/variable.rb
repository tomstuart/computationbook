require 'execjs/json'
require_relative '../syntax/variable'

class Variable
  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end

  def to_javascript
    "function (e) { return e[#{ExecJS::JSON.encode(name)}]; }"
  end
end
