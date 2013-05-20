class LCCall
  def to_ski
    SKICall.new(left.to_ski, right.to_ski)
  end
end
