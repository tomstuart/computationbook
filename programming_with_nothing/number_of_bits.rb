# Calculate the number of bits in a number using lamdba calculus

# Ruby helpers for translating output
def to_integer(proc)
  proc[-> n { n + 1 }][0]
end

def to_boolean(proc)
  proc[true][false]
end

# Some numbers
ZERO    = -> p { -> x {       x    } }
ONE     = -> p { -> x {     p[x]   } }
TWO     = -> p { -> x {   p[p[x]]  } }
THREE   = -> p { -> x { p[p[p[x]]] } }
FIVE    = -> p { -> x { p[p[p[p[p[x]]]]] } }
FIFTEEN = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] } }

# THE SOLUTION
#
# First in ruby to give a pattern to follow
#
#   def halve_and_count(pair)
#     x, count = pair
#
#     if x == 1
#       pair
#     else
#       [x / 2, count + 1]
#     end
#   end
#
#   def number_of_bits(x)
#     if x == 0
#       0
#     else
#       pair = [x, 0]
#
#       x.times do
#         pair = halve_and_count(pair)
#       end
#
#       pair.last + 1
#     end
#   end

# Then some intemediate results
TRUE = -> x { -> y { x } }
FALSE = -> x { -> y { y } }
IS_ZERO = -> n { n[ -> x { FALSE }][TRUE] }
IF = -> b { b }

INCREMENT = -> n { -> p { -> x { p[n[p][x]] } } }
PAIR = -> x { -> y { -> f { f[x][y] } } }
LEFT = -> p { p[ -> x { -> y { x } }] }
RIGHT = -> p { p[ -> x { -> y { y } }] }
SLIDE = -> p { PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]] }
DECREMENT = -> n { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] }
IS_ONE = -> n { IS_ZERO[DECREMENT[n]] }

# def subtract_two_and_count(pair)
#   x, count = pair
#
#   if x == 0 || x == 1
#     pair
#   else
#     [x - 2, count + 1]
#   end
# end
#
# def divide_by_two(x)
#   pair = [x, 0]
#
#   x.times do
#     pair = subtract_two_and_count(pair)
#   end
#
#   pair.last
# end

SUBTRACT_TWO_AND_COUNT = -> p {
  IF[IS_ZERO[LEFT[p]]][
    p
  ][IF[IS_ONE[LEFT[p]]][
    p
  ][
    PAIR[DECREMENT[DECREMENT[LEFT[p]]]][INCREMENT[RIGHT[p]]]
  ]]
}

DIVIDE_BY_TWO = -> x { RIGHT[x[SUBTRACT_TWO_AND_COUNT][PAIR[x][ZERO]]] }

# THE SOLUTION - in lambda calculus
HALVE_AND_COUNT = -> p {
  IF[IS_ONE[LEFT[p]]][
    p
  ][
    PAIR[DIVIDE_BY_TWO[LEFT[p]]][INCREMENT[RIGHT[p]]]
  ]
}

NUMBER_OF_BITS = -> x {
  IF[IS_ZERO[x]][
    ZERO
  ][
    INCREMENT[RIGHT[x[HALVE_AND_COUNT][PAIR[x][ZERO]]]]
  ]
}

describe 'to_integer' do
  it { to_integer(ZERO).should == 0 }
  it { to_integer(ONE).should == 1 }
end

describe 'to_boolean' do
  it { to_boolean(TRUE).should == true }
  it { to_boolean(FALSE).should == false }
end

describe 'IS_ZERO' do
  it { to_boolean(IS_ZERO[ZERO]).should == true }
  it { to_boolean(IS_ZERO[ONE]).should == false }
end

describe 'INCREMENT' do
  it { to_integer(INCREMENT[ZERO]).should == 1 }
  it { to_integer(INCREMENT[ONE]).should == 2 }
  it { to_integer(INCREMENT[TWO]).should == 3 }
end

describe 'DECREMENT' do
  it { to_integer(DECREMENT[ZERO]).should == 0 }
  it { to_integer(DECREMENT[ONE]).should == 0 }
  it { to_integer(DECREMENT[TWO]).should == 1 }
end

describe 'DIVIDE_BY_TWO' do
  it { to_integer(DIVIDE_BY_TWO[ZERO]).should == 0  }
  it { to_integer(DIVIDE_BY_TWO[ONE]).should == 0  }
  it { to_integer(DIVIDE_BY_TWO[TWO]).should == 1  }
  it { to_integer(DIVIDE_BY_TWO[THREE]).should == 1  }
  it { to_integer(DIVIDE_BY_TWO[HUNDRED]).should == 50  }
end

describe 'NUMBER_OF_BITS' do
  it { to_integer(NUMBER_OF_BITS[ZERO]).should == 0 }
  it { to_integer(NUMBER_OF_BITS[ONE]).should == 1 }
  it { to_integer(NUMBER_OF_BITS[TWO]).should == 2 }
  it { to_integer(NUMBER_OF_BITS[THREE]).should == 2 }
  it { to_integer(NUMBER_OF_BITS[FIVE]).should == 3 }
  it { to_integer(NUMBER_OF_BITS[FIFTEEN]).should == 4 }
  it { to_integer(NUMBER_OF_BITS[HUNDRED]).should == 7 }
end

