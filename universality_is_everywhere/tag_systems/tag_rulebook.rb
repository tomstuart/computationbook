class TagRulebook < Struct.new(:deletion_number, :rules)
  def next_string(string)
    rule_for(string).follow(string).slice(deletion_number..-1)
  end

  def rule_for(string)
    rules.detect { |r| r.applies_to?(string) }
  end

  def applies_to?(string)
    !rule_for(string).nil? && string.length >= deletion_number
  end
end
