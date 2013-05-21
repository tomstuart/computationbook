# encoding: utf-8

require_relative 'ski_call'
require_relative 'ski_symbol'

class SKICombinator < SKISymbol
  def as_a_function_of(name)
    SKICall.new(K, self)
  end
end

S, K, I, IOTA = [:S, :K, :I, :ɩ].map { |name| SKICombinator.new(name) }

class << S
  # reduce S[a][b][c] to a[c][b[c]]
  def call(a, b, c)
    SKICall.new(SKICall.new(a, c), SKICall.new(b, c))
  end

  def callable?(*arguments)
    arguments.length == 3
  end

  def to_iota
    SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA))))
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

  def to_iota
    SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA)))
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

  def to_iota
    SKICall.new(IOTA, IOTA)
  end
end

class << IOTA
  # reduce ɩ[a] to a[S][K]
  def call(a)
    SKICall.new(SKICall.new(a, S), K)
  end

  def callable?(*arguments)
    arguments.length == 1
  end
end
