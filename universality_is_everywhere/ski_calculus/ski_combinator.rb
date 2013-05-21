require_relative 'ski_call'
require_relative 'ski_symbol'

class SKICombinator < SKISymbol
  def as_a_function_of(name)
    SKICall.new(K, self)
  end
end

S, K, I = [:S, :K, :I].map { |name| SKICombinator.new(name) }

class << S
  # reduce S[a][b][c] to a[c][b[c]]
  def call(a, b, c)
    SKICall.new(SKICall.new(a, c), SKICall.new(b, c))
  end

  def callable?(*arguments)
    arguments.length == 3
  end
end

class << K
  # reduce K[a][b] to a
  def call(a, b)
    a
  end

  def callable?(*arguments)
    arguments.length == 2
  end
end

class << I
  # reduce I[a] to a
  def call(a)
    a
  end

  def callable?(*arguments)
    arguments.length == 1
  end
end
