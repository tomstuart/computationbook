require_relative '../finite_automata/nfa_design'
require_relative '../finite_automata/nfa_rulebook'
require_relative 'pattern'

class Empty
  include Pattern

  def to_s
    ''
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_states = [start_state]
    rulebook = NFARulebook.new([])

    NFADesign.new(start_state, accept_states, rulebook)
  end
end
