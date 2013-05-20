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

stack = Stack.new(['a', 'b', 'c', 'd', 'e'])
stack.top
stack.pop.pop.top
stack.push('x').push('y').top
stack.push('x').push('y').pop.top

rule = PDARule.new(1, '(', 2, '$', ['b', '$'])
configuration = PDAConfiguration.new(1, Stack.new(['$']))
rule.applies_to?(configuration, '(')

stack = Stack.new(['$']).push('x').push('y').push('z')
stack.top
stack = stack.pop; stack.top
stack = stack.pop; stack.top
rule.follow(configuration)

rulebook = DPDARulebook.new([
  PDARule.new(1, '(', 2, '$', ['b', '$']),
  PDARule.new(2, '(', 2, 'b', ['b', 'b']),
  PDARule.new(2, ')', 2, 'b', []),
  PDARule.new(2, nil, 1, '$', ['$'])
])
configuration = rulebook.next_configuration(configuration, '(')
configuration = rulebook.next_configuration(configuration, '(')
configuration = rulebook.next_configuration(configuration, ')')

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.accepting?
dpda.read_string('(()'); dpda.accepting?
dpda.current_configuration

configuration = PDAConfiguration.new(2, Stack.new(['$']))
rulebook.follow_free_moves(configuration)
DPDARulebook.new([PDARule.new(1, nil, 1, '$', ['$'])]).
  follow_free_moves(PDAConfiguration.new(1, Stack.new(['$'])))

dpda = DPDA.new(PDAConfiguration.new(1, Stack.new(['$'])), [1], rulebook)
dpda.read_string('(()('); dpda.accepting?
dpda.current_configuration
dpda.read_string('))()'); dpda.accepting?
dpda.current_configuration

dpda_design = DPDADesign.new(1, '$', [1], rulebook)
dpda_design.accepts?('(((((((((())))))))))')
dpda_design.accepts?('()(())((()))(()(()))')
dpda_design.accepts?('(()(()(()()(()()))()')
dpda_design.accepts?('())')

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

npda_design = NPDADesign.new(1, '$', [3], rulebook)
npda_design.accepts?('abba')
npda_design.accepts?('babbaabbab')
npda_design.accepts?('abb')
npda_design.accepts?('baabaa')

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
