class SKICall < Struct.new(:left, :right)
  def to_s
    "#{left}[#{right}]"
  end

  def inspect
    to_s
  end

  def combinator
    left.combinator
  end

  def arguments
    left.arguments + [right]
  end

  def reducible?
    left.reducible? || right.reducible? || combinator.callable?(*arguments)
  end

  def reduce
    if left.reducible?
      SKICall.new(left.reduce, right)
    elsif right.reducible?
      SKICall.new(left, right.reduce)
    else
      combinator.call(*arguments)
    end
  end

  def as_a_function_of(name)
    left_function = left.as_a_function_of(name)
    right_function = right.as_a_function_of(name)

    SKICall.new(SKICall.new(S, left_function), right_function)
  end
end
