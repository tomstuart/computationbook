require_relative '../tag_systems/tag_rulebook'
require_relative 'cyclic_tag_rule'
require_relative 'cyclic_tag_rulebook'

class TagRulebook
  def alphabet
    rules.flat_map(&:alphabet).uniq
  end

  def cyclic_rules(encoder)
    encoder.alphabet.map { |character| cyclic_rule_for(character, encoder) }
  end

  def cyclic_rule_for(character, encoder)
    rule = rule_for(character)

    if rule.nil?
      CyclicTagRule.new('')
    else
      rule.to_cyclic(encoder)
    end
  end

  def cyclic_padding_rules(encoder)
    Array.new(encoder.alphabet.length, CyclicTagRule.new('')) * (deletion_number - 1)
  end

  def to_cyclic(encoder)
    CyclicTagRulebook.new(cyclic_rules(encoder) + cyclic_padding_rules(encoder))
  end
end
