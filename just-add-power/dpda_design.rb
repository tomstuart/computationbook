require_relative 'dpda'
require_relative 'pda_configuration'
require_relative 'stack'

class DPDADesign < Struct.new(:start_state, :bottom_character,
                              :accept_states, :rulebook)
  def accepts?(string)
    to_dpda.tap { |dpda| dpda.read_string(string) }.accepting?
  end

  def to_dpda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    DPDA.new(start_configuration, accept_states, rulebook)
  end
end
