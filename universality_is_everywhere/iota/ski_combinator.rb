# encoding: utf-8

require_relative '../ski_calculus/ski_combinator'
require_relative 'ski_call'

IOTA = SKICombinator.new(:ɩ)

class << IOTA
  # reduce ɩ[a] to a[S][K]
  def call(a)
    SKICall.new(SKICall.new(a, S), K)
  end

  def callable?(*arguments)
    arguments.length == 1
  end
end

class << S
  def to_iota
    SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA))))
  end
end

class << K
  def to_iota
    SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA)))
  end
end

class << I
  def to_iota
    SKICall.new(IOTA, IOTA)
  end
end
