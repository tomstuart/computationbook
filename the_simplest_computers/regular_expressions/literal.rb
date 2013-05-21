require_relative '../finite_automata/fa_rule'
require_relative '../finite_automata/nfa_design'
require_relative '../finite_automata/nfa_rulebook'
require_relative 'pattern'

class Literal < Struct.new(:character)
  include Pattern

  def to_s
    character
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_state = Object.new
    rule = FARule.new(start_state, character, accept_state)
    rulebook = NFARulebook.new([rule])

    NFADesign.new(start_state, [accept_state], rulebook)
  end
end
