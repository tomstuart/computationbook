require_relative '../tag_systems/tag_system'
require_relative 'cyclic_tag_encoder'

class TagSystem
  def alphabet
    (rulebook.alphabet + current_string.chars.entries).uniq.sort
  end

  def encoder
    CyclicTagEncoder.new(alphabet)
  end

  def to_cyclic
    TagSystem.new(encoder.encode_string(current_string), rulebook.to_cyclic(encoder))
  end
end
