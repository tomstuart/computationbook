TAPE        = -> l { -> m { -> r { -> b { PAIR[PAIR[l][m]][PAIR[r][b]] } } } }
TAPE_LEFT   = -> t { LEFT[LEFT[t]] }
TAPE_MIDDLE = -> t { RIGHT[LEFT[t]] }
TAPE_RIGHT  = -> t { LEFT[RIGHT[t]] }
TAPE_BLANK  = -> t { RIGHT[RIGHT[t]] }
TAPE_WRITE = -> t { -> c { TAPE[TAPE_LEFT[t]][c][TAPE_RIGHT[t]][TAPE_BLANK[t]] } }
TAPE_MOVE_HEAD_RIGHT =
  -> t {
    TAPE[
      PUSH[TAPE_LEFT[t]][TAPE_MIDDLE[t]]
    ][
      IF[IS_EMPTY[TAPE_RIGHT[t]]][
        TAPE_BLANK[t]
      ][
        FIRST[TAPE_RIGHT[t]]
      ]
    ][
      IF[IS_EMPTY[TAPE_RIGHT[t]]][
        EMPTY
      ][
        REST[TAPE_RIGHT[t]]
      ]
    ][
      TAPE_BLANK[t]
    ]
  }
current_tape = TAPE[EMPTY][ZERO][EMPTY][ZERO]
current_tape = TAPE_WRITE[current_tape][ONE]
current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
current_tape = TAPE_WRITE[current_tape][TWO]
current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
current_tape = TAPE_WRITE[current_tape][THREE]
current_tape = TAPE_MOVE_HEAD_RIGHT[current_tape]
to_array(TAPE_LEFT[current_tape]).map { |p| to_integer(p) }
to_integer(TAPE_MIDDLE[current_tape])
to_array(TAPE_RIGHT[current_tape]).map { |p| to_integer(p) }

def zero
  0
end

def increment(n)
  n + 1
end

zero
increment(zero)
increment(increment(zero))

def two
  increment(increment(zero))
end

two

def three
  increment(two)
end

three

def add_three(x)
  increment(increment(increment(x)))
end

add_three(two)

def recurse(f, g, *values)
  *other_values, last_value = values

  if last_value.zero?
    send(f, *other_values)
  else
    easier_last_value = last_value - 1
    easier_values = other_values + [easier_last_value]

    easier_result = recurse(f, g, *easier_values)
    send(g, *easier_values, easier_result)
  end
end

def add_zero_to_x(x)
  x
end

def increment_easier_result(x, easier_y, easier_result)
  increment(easier_result)
end

def add(x, y)
  recurse(:add_zero_to_x, :increment_easier_result, x, y)
end

add(two, three)

def multiply_x_by_zero(x)
  zero
end

def add_x_to_easier_result(x, easier_y, easier_result)
  add(x, easier_result)
end

def multiply(x, y)
  recurse(:multiply_x_by_zero, :add_x_to_easier_result, x, y)
end

def easier_x(easier_x, easier_result)
  easier_x
end

def decrement(x)
  recurse(:zero, :easier_x, x)
end

def subtract_zero_from_x(x)
  x
end

def decrement_easier_result(x, easier_y, easier_result)
  decrement(easier_result)
end

def subtract(x, y)
  recurse(:subtract_zero_from_x, :decrement_easier_result, x, y)
end

multiply(two, three)

def six
  multiply(two, three)
end

decrement(six)
subtract(six, two)
subtract(two, six)

def minimize
  n = 0
  n = n + 1 until yield(n).zero?
  n
end

def divide(x, y)
  minimize { |n| subtract(increment(x), multiply(y, increment(n))) }
end

divide(six, two)

def ten
  increment(multiply(three, three))
end

ten
divide(ten, three)
divide(six, zero)

class SKISymbol < Struct.new(:name)
  def to_s
    name.to_s
  end

  def inspect
    to_s
  end

  def combinator
    self
  end

  def arguments
    []
  end

  def callable?(*arguments)
    false
  end

  def reducible?
    false
  end

  def as_a_function_of(name)
    if self.name == name
      I
    else
      SKICall.new(K, self)
    end
  end

  def to_iota
    self
  end
end

class SKICall < Struct.new(:left, :right)
  def to_s
    "#{left}[#{right}]"
  end

  def inspect
    to_s
  end

  def combinator
    left.combinator
  end

  def arguments
    left.arguments + [right]
  end

  def reducible?
    left.reducible? || right.reducible? || combinator.callable?(*arguments)
  end

  def reduce
    if left.reducible?
      SKICall.new(left.reduce, right)
    elsif right.reducible?
      SKICall.new(left, right.reduce)
    else
      combinator.call(*arguments)
    end
  end

  def as_a_function_of(name)
    left_function = left.as_a_function_of(name)
    right_function = right.as_a_function_of(name)

    SKICall.new(SKICall.new(S, left_function), right_function)
  end

  def to_iota
    SKICall.new(left.to_iota, right.to_iota)
  end
end

class SKICombinator < SKISymbol
  def as_a_function_of(name)
    SKICall.new(K, self)
  end
end

S, K, I = [:S, :K, :I].map { |name| SKICombinator.new(name) }
x = SKISymbol.new(:x)
expression = SKICall.new(SKICall.new(S, K), SKICall.new(I, x))

# reduce S[a][b][c] to a[c][b[c]]
def S.call(a, b, c)
  SKICall.new(SKICall.new(a, c), SKICall.new(b, c))
end

# reduce K[a][b] to a
def K.call(a, b)
  a
end

# reduce I[a] to a
def I.call(a)
  a
end

y, z = SKISymbol.new(:y), SKISymbol.new(:z)
S.call(x, y, z)
expression = SKICall.new(SKICall.new(SKICall.new(S, x), y), z)
combinator = expression.left.left.left
first_argument = expression.left.left.right
second_argument = expression.left.right
third_argument = expression.right
combinator.call(first_argument, second_argument, third_argument)

expression
combinator = expression.combinator
arguments = expression.arguments
combinator.call(*arguments)
expression = SKICall.new(SKICall.new(x, y), z)
combinator = expression.combinator
arguments = expression.arguments
combinator.call(*arguments)
expression = SKICall.new(SKICall.new(S, x), y)
combinator = expression.combinator
arguments = expression.arguments
combinator.call(*arguments)

def S.callable?(*arguments)
  arguments.length == 3
end

def K.callable?(*arguments)
  arguments.length == 2
end

def I.callable?(*arguments)
  arguments.length == 1
end

def add(x, y)
  x + y
end

add_method = method(:add)
add_method.arity
expression = SKICall.new(SKICall.new(x, y), z)
expression.combinator.callable?(*expression.arguments)
expression = SKICall.new(SKICall.new(S, x), y)
expression.combinator.callable?(*expression.arguments)
expression = SKICall.new(SKICall.new(SKICall.new(S, x), y), z)
expression.combinator.callable?(*expression.arguments)

swap = SKICall.new(SKICall.new(S, SKICall.new(K, SKICall.new(S, I))), K)
expression = SKICall.new(SKICall.new(swap, x), y)

while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression

original = SKICall.new(SKICall.new(S, K), I)
function = original.as_a_function_of(:x)
function.reducible?
expression = SKICall.new(function, y)

while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression

expression == original
original = SKICall.new(SKICall.new(S, x), I)
function = original.as_a_function_of(:x)
expression = SKICall.new(function, y)

while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression

expression == original

class LCVariable
  def to_ski
    SKISymbol.new(name)
  end
end

class LCCall
  def to_ski
    SKICall.new(left.to_ski, right.to_ski)
  end
end

class LCFunction
  def to_ski
    body.to_ski.as_a_function_of(parameter)
  end
end

two = LambdaCalculusParser.new.parse('-> p { -> x { p[p[x]] } }').to_ast
two.to_ski
inc, zero = SKISymbol.new(:inc), SKISymbol.new(:zero)
expression = SKICall.new(SKICall.new(two.to_ski, inc), zero)
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
identity = SKICall.new(SKICall.new(S, K), K)
expression = SKICall.new(identity, x)
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
IOTA = SKICombinator.new('ɩ')

# reduce ɩ[a] to a[S][K]
def IOTA.call(a)
  SKICall.new(SKICall.new(a, S), K)
end

def IOTA.callable?(*arguments)
  arguments.length == 1
end

def S.to_iota
  SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA))))
end

def K.to_iota
  SKICall.new(IOTA, SKICall.new(IOTA, SKICall.new(IOTA, IOTA)))
end

def I.to_iota
  SKICall.new(IOTA, IOTA)
end

expression = S.to_iota
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
expression = K.to_iota
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
expression = I.to_iota
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
identity = SKICall.new(SKICall.new(S, K), SKICall.new(K, K))
expression = SKICall.new(identity, x)
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
two
two.to_ski
two.to_ski.to_iota
expression = SKICall.new(SKICall.new(two.to_ski.to_iota, inc), zero)
expression = expression.reduce while expression.reducible?
expression

class TagRule < Struct.new(:first_character, :append_characters)
  def applies_to?(string)
    string.chars.first == first_character
  end

  def follow(string)
    string + append_characters
  end

  def alphabet
    ([first_character] + append_characters.chars.entries).uniq
  end

  def to_cyclic(encoder)
    CyclicTagRule.new(encoder.encode_string(append_characters))
  end
end

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

rulebook = TagRulebook.new(2, [TagRule.new('a', 'aa'), TagRule.new('b', 'bbbb')])
system = TagSystem.new('aabbbbbb', rulebook)
4.times do
  puts system.current_string
  system.step
end; puts system.current_string

rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), TagRule.new('b', 'dddd')])
system = TagSystem.new('aabbbbbb', rulebook)
system.run
rulebook = TagRulebook.new(2, [TagRule.new('a', 'cc'), TagRule.new('b', 'd')])
system = TagSystem.new('aabbbbbbbbbbbb', rulebook)
system.run
rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'), TagRule.new('b', 'dd')])
system = TagSystem.new('aabbbb', rulebook)
system.run
rulebook = TagRulebook.new(2, [
  TagRule.new('a', 'cc'), TagRule.new('b', 'dddd'), # double
  TagRule.new('c', 'eeff'), TagRule.new('d', 'ff')  # increment
])
system = TagSystem.new('aabbbb', rulebook)
system.run
rulebook = TagRulebook.new(2, [
  TagRule.new('a', 'cc'), TagRule.new('b', 'd'),
  TagRule.new('c', 'eo'), TagRule.new('d', ''),
  TagRule.new('e', 'e')
])
system = TagSystem.new('aabbbbbbbb', rulebook)
system.run
system = TagSystem.new('aabbbbbbbbbb', rulebook)
system.run

class CyclicTagRule < TagRule
  FIRST_CHARACTER = '1'

  def initialize(append_characters)
    super(FIRST_CHARACTER, append_characters)
  end

  def inspect
    "#<CyclicTagRule #{append_characters.inspect}>"
  end
end

class CyclicTagRulebook < Struct.new(:rules)
  DELETION_NUMBER = 1

  def initialize(rules)
    super(rules.cycle)
  end

  def applies_to?(string)
    string.length >= DELETION_NUMBER
  end

  def next_string(string)
    follow_next_rule(string).slice(DELETION_NUMBER..-1)
  end

  def follow_next_rule(string)
    rule = rules.next

    if rule.applies_to?(string)
      rule.follow(string)
    else
      string
    end
  end
end

numbers = [1, 2, 3].cycle
numbers.next
numbers.next
numbers.next
numbers.next
[:a, :b, :c, :d].cycle.take(10)
rulebook = CyclicTagRulebook.new([
  CyclicTagRule.new('1'), CyclicTagRule.new('0010'), CyclicTagRule.new('10')
])
system = TagSystem.new('11', rulebook)
16.times do
  puts system.current_string
  system.step
end; puts system.current_string
20.times do
  puts system.current_string
  system.step
end; puts system.current_string

rulebook = TagRulebook.new(2, [TagRule.new('a', 'ccdd'), TagRule.new('b', 'dd')])
system = TagSystem.new('aabbbb', rulebook)
system.alphabet

class CyclicTagEncoder < Struct.new(:alphabet)
  def encode_string(string)
    string.chars.map { |character| encode_character(character) }.join
  end

  def encode_character(character)
    character_position = alphabet.index(character)
    (0...alphabet.length).map { |n| n == character_position ? '1' : '0' }.join
  end
end

encoder = system.encoder
encoder.encode_character('c')
encoder.encode_string('cab')

rule = system.rulebook.rules.first
rule.to_cyclic(encoder)

system.rulebook.cyclic_rules(encoder)

system.rulebook.cyclic_padding_rules(encoder)

cyclic_system = system.to_cyclic
cyclic_system.run
