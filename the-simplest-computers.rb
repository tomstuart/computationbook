rulebook = DFARulebook.new([
  FARule.new(1, 'a', 2), FARule.new(1, 'b', 1),
  FARule.new(2, 'a', 2), FARule.new(2, 'b', 3),
  FARule.new(3, 'a', 3), FARule.new(3, 'b', 3)
])
rulebook.next_state(1, 'a')
rulebook.next_state(1, 'b')
rulebook.next_state(2, 'b')

DFA.new(1, [1, 3], rulebook).accepting?
DFA.new(1, [3], rulebook).accepting?

dfa = DFA.new(1, [3], rulebook); dfa.accepting?
dfa.read_character('b'); dfa.accepting?
3.times do dfa.read_character('a') end; dfa.accepting?
dfa.read_character('b'); dfa.accepting?

dfa = DFA.new(1, [3], rulebook); dfa.accepting?
dfa.read_string('baaab'); dfa.accepting?

dfa_design = DFADesign.new(1, [3], rulebook)
dfa_design.accepts?('a')
dfa_design.accepts?('baa')
dfa_design.accepts?('baba')

rulebook = NFARulebook.new([
  FARule.new(1, 'a', 1), FARule.new(1, 'b', 1), FARule.new(1, 'b', 2),
  FARule.new(2, 'a', 3), FARule.new(2, 'b', 3),
  FARule.new(3, 'a', 4), FARule.new(3, 'b', 4)
])
rulebook.next_states(Set[1], 'b')
rulebook.next_states(Set[1, 2], 'a')
rulebook.next_states(Set[1, 3], 'b')

NFA.new(Set[1], [4], rulebook).accepting?
NFA.new(Set[1, 2, 4], [4], rulebook).accepting?

nfa = NFA.new(Set[1], [4], rulebook); nfa.accepting?
nfa.read_character('b'); nfa.accepting?
nfa.read_character('a'); nfa.accepting?
nfa.read_character('b'); nfa.accepting?
nfa = NFA.new(Set[1], [4], rulebook)
nfa.accepting?
nfa.read_string('bbbbb'); nfa.accepting?

nfa_design = NFADesign.new(1, [4], rulebook)
nfa_design.accepts?('bab')
nfa_design.accepts?('bbbbb')
nfa_design.accepts?('bbabb')
rulebook = NFARulebook.new([
  FARule.new(1, nil, 2), FARule.new(1, nil, 4),
  FARule.new(2, 'a', 3),
  FARule.new(3, 'a', 2),
  FARule.new(4, 'a', 5),
  FARule.new(5, 'a', 6),
  FARule.new(6, 'a', 4)
])
rulebook.next_states(Set[1], nil)

rulebook.follow_free_moves(Set[1])

nfa_design = NFADesign.new(1, [2, 4], rulebook)
nfa_design.accepts?('aa')
nfa_design.accepts?('aaa')
nfa_design.accepts?('aaaaa')
nfa_design.accepts?('aaaaaa')

pattern =
  Repeat.new(
    Choose.new(
      Concatenate.new(Literal.new('a'), Literal.new('b')),
      Literal.new('a')
    )
  )

nfa_design = Empty.new.to_nfa_design
nfa_design.accepts?('')
nfa_design.accepts?('a')
nfa_design = Literal.new('a').to_nfa_design
nfa_design.accepts?('')
nfa_design.accepts?('a')
nfa_design.accepts?('b')

Empty.new.matches?('a')
Literal.new('a').matches?('a')

pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
pattern.matches?('a')
pattern.matches?('ab')
pattern.matches?('abc')
pattern =
  Concatenate.new(
    Literal.new('a'),
    Concatenate.new(Literal.new('b'), Literal.new('c'))
  )
pattern.matches?('a')
pattern.matches?('ab')
pattern.matches?('abc')

pattern = Choose.new(Literal.new('a'), Literal.new('b'))
pattern.matches?('a')
pattern.matches?('b')
pattern.matches?('c')

pattern = Repeat.new(Literal.new('a'))
pattern.matches?('')
pattern.matches?('a')
pattern.matches?('aaaa')
pattern.matches?('b')
pattern =
  Repeat.new(
    Concatenate.new(
      Literal.new('a'),
      Choose.new(Empty.new, Literal.new('b'))
    )
  )
pattern.matches?('')
pattern.matches?('a')
pattern.matches?('ab')
pattern.matches?('aba')
pattern.matches?('abab')
pattern.matches?('abaab')
pattern.matches?('abba')

require 'treetop'
Treetop.load('pattern')
parse_tree = PatternParser.new.parse('(a(|b))*')
pattern = parse_tree.to_ast
pattern.matches?('abaab')
pattern.matches?('abba')

rulebook = NFARulebook.new([
  FARule.new(1, 'a', 1), FARule.new(1, 'a', 2), FARule.new(1, nil, 2),
  FARule.new(2, 'b', 3),
  FARule.new(3, 'b', 1), FARule.new(3, nil, 2)
])
nfa_design = NFADesign.new(1, [3], rulebook)
nfa_design.to_nfa.current_states
nfa_design.to_nfa(Set[2]).current_states
nfa_design.to_nfa(Set[3]).current_states
nfa = nfa_design.to_nfa(Set[2, 3])
nfa.read_character('b'); nfa.current_states

simulation = NFASimulation.new(nfa_design)
simulation.next_state(Set[1, 2], 'a')
simulation.next_state(Set[1, 2], 'b')
simulation.next_state(Set[3, 2], 'b')
simulation.next_state(Set[1, 3, 2], 'b')
simulation.next_state(Set[1, 3, 2], 'a')

rulebook.alphabet
simulation.rules_for(Set[1, 2])
simulation.rules_for(Set[3, 2])

start_state = nfa_design.to_nfa.current_states
simulation.discover_states_and_rules(Set[start_state])
nfa_design.to_nfa(Set[1, 2]).accepting?
nfa_design.to_nfa(Set[2, 3]).accepting?

dfa_design = simulation.to_dfa_design
dfa_design.accepts?('aaa')
dfa_design.accepts?('aab')
dfa_design.accepts?('bbbabb')
