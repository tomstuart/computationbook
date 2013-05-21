require_relative '../tag_systems/tag_rule'
require_relative 'cyclic_tag_rule'

class TagRule
  def alphabet
    ([first_character] + append_characters.chars.entries).uniq
  end

  def to_cyclic(encoder)
    CyclicTagRule.new(encoder.encode_string(append_characters))
  end
end
