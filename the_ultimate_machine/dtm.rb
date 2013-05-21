class DTM < Struct.new(:current_configuration, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_configuration.state)
  end

  def step
    self.current_configuration = rulebook.next_configuration(current_configuration)
  end

  def run
    step until accepting? || stuck?
  end

  def stuck?
    !accepting? && !rulebook.applies_to?(current_configuration)
  end
end
