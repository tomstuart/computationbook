require_relative 'ski_call'

class SKISymbol < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    to_s
  end

  def combinator
    self
  end

  def arguments
    []
  end

  def callable?(*arguments)
    false
  end

  def reducible?
    false
  end

  def as_a_function_of(name)
    if self.name == name
      I
    else
      SKICall.new(K, self)
    end
  end
end
