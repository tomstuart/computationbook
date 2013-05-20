rulebook = NFARulebook.new([
  FARule.new(0, '(', 1), FARule.new(1, ')', 0),
  FARule.new(1, '(', 2), FARule.new(2, ')', 1),
  FARule.new(2, '(', 3), FARule.new(3, ')', 2)
])
nfa_design = NFADesign.new(0, [0], rulebook)
nfa_design.accepts?('(()')
nfa_design.accepts?('())')
nfa_design.accepts?('(())')
nfa_design.accepts?('(()(()()))')
nfa_design.accepts?('(((())))')

balanced =
  /
    \A              # match beginning of string
    (?<brackets>    # begin subexpression called "brackets"
      \(            # match a literal opening bracket
      \g<brackets>* # match "brackets" subexpression zero or more times
      \)            # match a literal closing bracket
    )               # end subexpression
    *               # repeat the whole pattern zero or more times
    \z              # match end of string
  /x
['(()', '())', '(())', '(()(()()))', '((((((((((()))))))))))'].grep(balanced)

class Stack < Struct.new(:contents)
  def push(character)
    Stack.new([character] + contents)
  end

  def pop
    Stack.new(contents.drop(1))
  end

  def top
    contents.first
  end

  def inspect
    "#<Stack (#{top})#{contents.drop(1).join}>"
  end
end

stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
stack.top
stack.pop.pop.top
stack.push('x').push('y').top
stack.push('x').push('y').pop.top

class PDAConfiguration < Struct.new(:state, :stack)
end

class PDARule < Struct.new(:state, :character, :next_state,
                           :pop_character, :push_characters)
  def applies_to?(configuration, character)
    self.state == configuration.state &&
      self.pop_character == configuration.stack.top &&
      self.character == character
  end
end

rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
configuration = PDAConfiguration.new(1, Stack.new(['$']))
rule.applies_to?(configuration, '(')

class PDARule
  def follow(configuration)
    PDAConfiguration.new(next_state, next_stack(configuration))
  end

  def next_stack(configuration)
    popped_stack = configuration.stack.pop

    push_characters.reverse.
      inject(popped_stack) { |stack, character| stack.push(character) }
  end
end

stack = Stack.new(['$']).push('x').push('y').push('z')
stack.top
stack = stack.pop; stack.top
stack = stack.pop; stack.top
rule.follow(configuration)

class DPDARulebook < Struct.new(:rules)
  def next_configuration(configuration, character)
    rule_for(configuration, character).follow(configuration)
  end

  def rule_for(configuration, character)
    rules.detect { |rule| rule.applies_to?(configuration, character) }
  end
end

rulebook = DPDARulebook.new([
  PDARule.new(1, '(', 2, '$', ['b', '$']),
  PDARule.new(2, '(', 2, 'b', ['b', 'b']),
  PDARule.new(2, ')', 2, 'b', []),
  PDARule.new(2, nil, 1, '$', ['$'])
])
configuration = rulebook.next_configuration(configuration, '(')
configuration = rulebook.next_configuration(configuration, '(')
configuration = rulebook.next_configuration(configuration, ')')

class DPDA < Struct.new(:current_configuration, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_configuration.state)
  end

  def read_character(character)
    self.current_configuration =
      rulebook.next_configuration(current_configuration, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end
end

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.accepting?
dpda.read_string('(()'); dpda.accepting?
dpda.current_configuration

class DPDARulebook
  def applies_to?(configuration, character)
    !rule_for(configuration, character).nil?
  end

  def follow_free_moves(configuration)
    if applies_to?(configuration, nil)
      follow_free_moves(next_configuration(configuration, nil))
    else
      configuration
    end
  end
end

configuration = PDAConfiguration.new(2, Stack.new(['$']))
rulebook.follow_free_moves(configuration)
DPDARulebook.new([PDARule.new(1, nil, 1, '$', ['$'])]).
  follow_free_moves(PDAConfiguration.new(1, Stack.new(['$'])))

class DPDA
  def current_configuration
    rulebook.follow_free_moves(super)
  end
end

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('(()('); dpda.accepting?
dpda.current_configuration
dpda.read_string('))()'); dpda.accepting?
dpda.current_configuration

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

dpda_design = DPDADesign.new(1, '$', [1], rulebook)
dpda_design.accepts?('(((((((((())))))))))')
dpda_design.accepts?('()(())((()))(()(()))')
dpda_design.accepts?('(()(()(()()(()()))()')
dpda_design.accepts?('())')

class PDAConfiguration
  STUCK_STATE = Object.new

  def stuck
    PDAConfiguration.new(STUCK_STATE, stack)
  end

  def stuck?
    state == STUCK_STATE
  end
end

class DPDA
  def next_configuration(character)
    if rulebook.applies_to?(current_configuration, character)
      rulebook.next_configuration(current_configuration, character)
    else
      current_configuration.stuck
    end
  end

  def stuck?
    current_configuration.stuck?
  end

  def read_character(character)
    self.current_configuration = next_configuration(character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character) unless stuck?
    end
  end
end

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('())'); dpda.current_configuration
dpda.accepting?
dpda.stuck?
dpda_design.accepts?('())')
rulebook = DPDARulebook.new([
  PDARule.new(1, 'a', 2, '$', ['a', '$']),
  PDARule.new(1, 'b', 2, '$', ['b', '$']),
  PDARule.new(2, 'a', 2, 'a', ['a', 'a']),
  PDARule.new(2, 'b', 2, 'b', ['b', 'b']),
  PDARule.new(2, 'a', 2, 'b', []),
  PDARule.new(2, 'b', 2, 'a', []),
  PDARule.new(2, nil, 1, '$', ['$'])
])
dpda_design = DPDADesign.new(1, '$', [1], rulebook)
dpda_design.accepts?('ababab')
dpda_design.accepts?('bbbaaaab')
dpda_design.accepts?('baa')
rulebook = DPDARulebook.new([
  PDARule.new(1, 'a', 1, '$', ['a', '$']),
  PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
  PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
  PDARule.new(1, 'b', 1, '$', ['b', '$']),
  PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
  PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
  PDARule.new(1, 'm', 2, '$', ['$']),
  PDARule.new(1, 'm', 2, 'a', ['a']),
  PDARule.new(1, 'm', 2, 'b', ['b']),
  PDARule.new(2, 'a', 2, 'a', []),
  PDARule.new(2, 'b', 2, 'b', []),
  PDARule.new(2, nil, 3, '$', ['$'])
])
dpda_design = DPDADesign.new(1, '$', [3], rulebook)
dpda_design.accepts?('abmba')
dpda_design.accepts?('babbamabbab')
dpda_design.accepts?('abmb')
dpda_design.accepts?('baambaa')

require 'set'

class NPDARulebook < Struct.new(:rules)
  def next_configurations(configurations, character)
    configurations.flat_map { |config| follow_rules_for(config, character) }.to_set
  end

  def follow_rules_for(configuration, character)
    rules_for(configuration, character).map { |rule| rule.follow(configuration) }
  end

  def rules_for(configuration, character)
    rules.select { |rule| rule.applies_to?(configuration, character) }
  end
end

class NPDARulebook
  def follow_free_moves(configurations)
    more_configurations = next_configurations(configurations, nil)

    if more_configurations.subset?(configurations)
      configurations
    else
      follow_free_moves(configurations + more_configurations)
    end
  end
end

class NPDA < Struct.new(:current_configurations, :accept_states, :rulebook)
  def accepting?
    current_configurations.any? { |config| accept_states.include?(config.state) }
  end

  def read_character(character)
    self.current_configurations =
      rulebook.next_configurations(current_configurations, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character(character)
    end
  end

  def current_configurations
    rulebook.follow_free_moves(super)
  end
end

rulebook = NPDARulebook.new([
  PDARule.new(1, 'a', 1, '$', ['a', '$']),
  PDARule.new(1, 'a', 1, 'a', ['a', 'a']),
  PDARule.new(1, 'a', 1, 'b', ['a', 'b']),
  PDARule.new(1, 'b', 1, '$', ['b', '$']),
  PDARule.new(1, 'b', 1, 'a', ['b', 'a']),
  PDARule.new(1, 'b', 1, 'b', ['b', 'b']),
  PDARule.new(1, nil, 2, '$', ['$']),
  PDARule.new(1, nil, 2, 'a', ['a']),
  PDARule.new(1, nil, 2, 'b', ['b']),
  PDARule.new(2, 'a', 2, 'a', []),
  PDARule.new(2, 'b', 2, 'b', []),
  PDARule.new(2, nil, 3, '$', ['$'])
])
configuration = PDAConfiguration.new(1, Stack.new(['$']))
npda = NPDA.new(Set[configuration], [3], rulebook)
npda.accepting?
npda.current_configurations
npda.read_string('abb'); npda.accepting?
npda.current_configurations
npda.read_character('a'); npda.accepting?
npda.current_configurations

class NPDADesign < Struct.new(:start_state, :bottom_character,
                              :accept_states, :rulebook)
  def accepts?(string)
    to_npda.tap { |npda| npda.read_string(string) }.accepting?
  end

  def to_npda
    start_stack = Stack.new([bottom_character])
    start_configuration = PDAConfiguration.new(start_state, start_stack)
    NPDA.new(Set[start_configuration], accept_states, rulebook)
  end
end

npda_design = NPDADesign.new(1, '$', [3], rulebook)
npda_design.accepts?('abba')
npda_design.accepts?('babbaabbab')
npda_design.accepts?('abb')
npda_design.accepts?('baabaa')

class LexicalAnalyzer < Struct.new(:string)
  GRAMMAR = [
    { token: 'i', pattern: /if/         }, # if keyword
    { token: 'e', pattern: /else/       }, # else keyword
    { token: 'w', pattern: /while/      }, # while keyword
    { token: 'd', pattern: /do-nothing/ }, # do-nothing keyword
    { token: '(', pattern: /\(/         }, # opening bracket
    { token: ')', pattern: /\)/         }, # closing bracket
    { token: '{', pattern: /\{/         }, # opening curly bracket
    { token: '}', pattern: /\}/         }, # closing curly bracket
    { token: ';', pattern: /;/          }, # semicolon
    { token: '=', pattern: /=/          }, # equals sign
    { token: '+', pattern: /\+/         }, # addition sign
    { token: '*', pattern: /\*/         }, # multiplication sign
    { token: '<', pattern: /</          }, # less-than sign
    { token: 'n', pattern: /[0-9]+/     }, # number
    { token: 'b', pattern: /true|false/ }, # boolean
    { token: 'v', pattern: /[a-z]+/     }  # variable name
  ]

  def analyze
    [].tap do |tokens|
      while more_tokens?
        tokens.push(next_token)
      end
    end
  end

  def more_tokens?
    !string.empty?
  end

  def next_token
    rule, match = rule_matching(string)
    self.string = string_after(match)
    rule[:token]
  end

  def rule_matching(string)
    matches = GRAMMAR.map { |rule| match_at_beginning(rule[:pattern], string) }
    rules_with_matches = GRAMMAR.zip(matches).reject { |rule, match| match.nil? }
    rule_with_longest_match(rules_with_matches)
  end

  def match_at_beginning(pattern, string)
    /\A#{pattern}/.match(string)
  end

  def rule_with_longest_match(rules_with_matches)
    rules_with_matches.max_by { |rule, match| match.to_s.length }
  end

  def string_after(match)
    match.post_match.lstrip
  end
end

LexicalAnalyzer.new('y = x * 7').analyze
LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze
LexicalAnalyzer.new('if (x < 10) { y = true; x = 0 } else { do-nothing }').analyze
LexicalAnalyzer.new('x = false').analyze
LexicalAnalyzer.new('x = falsehood').analyze
start_rule = PDARule.new(1, nil, 2, '$', ['S', '$'])
symbol_rules =
  [
    # <statement> ::= <while> | <assign>
    PDARule.new(2, nil, 2, 'S', ['W']),
    PDARule.new(2, nil, 2, 'S', ['A']),

    # <while> ::= 'w' '(' <expression> ')' '{' <statement> '}'
    PDARule.new(2, nil, 2, 'W', ['w', '(', 'E', ')', '{', 'S', '}']),

    # <assign> ::= 'v' '=' <expression>
    PDARule.new(2, nil, 2, 'A', ['v', '=', 'E']),

    # <expression> ::= <less-than>
    PDARule.new(2, nil, 2, 'E', ['L']),

    # <less-than> ::= <multiply> '<' <less-than> | <multiply>
    PDARule.new(2, nil, 2, 'L', ['M', '<', 'L']),
    PDARule.new(2, nil, 2, 'L', ['M']),

    # <multiply> ::= <term> '*' <multiply> | <term>
    PDARule.new(2, nil, 2, 'M', ['T', '*', 'M']),
    PDARule.new(2, nil, 2, 'M', ['T']),

    # <term> ::= 'n' | 'v'
    PDARule.new(2, nil, 2, 'T', ['n']),
    PDARule.new(2, nil, 2, 'T', ['v'])
  ]
token_rules =
  LexicalAnalyzer::GRAMMAR.map do |rule|
    PDARule.new(2, rule[:token], 2, rule[:token], [])
  end
stop_rule = PDARule.new(2, nil, 3, '$', ['$'])
rulebook = NPDARulebook.new([start_rule, stop_rule] + symbol_rules + token_rules)
npda_design = NPDADesign.new(1, '$', [3], rulebook)
token_string = LexicalAnalyzer.new('while (x < 5) { x = x * 3 }').analyze.join
npda_design.accepts?(token_string)
npda_design.accepts?(LexicalAnalyzer.new('while (x < 5 x = x * }').analyze.join)
