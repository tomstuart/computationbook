require_relative '../ski_calculus/ski_call'

class SKICall
  def to_iota
    SKICall.new(left.to_iota, right.to_iota)
  end
end
