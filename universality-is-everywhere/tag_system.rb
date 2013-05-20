class TagSystem < Struct.new(:current_string, :rulebook)
  def step
    self.current_string = rulebook.next_string(current_string)
  end

  def run
    while rulebook.applies_to?(current_string)
      puts current_string
      step
    end

    puts current_string
  end

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
