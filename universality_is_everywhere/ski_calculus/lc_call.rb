require_relative '../../programming_with_nothing/lambda_calculus/lc_call'
require_relative 'ski_call'

class LCCall
  def to_ski
    SKICall.new(left.to_ski, right.to_ski)
  end
end
