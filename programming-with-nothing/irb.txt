-> x { -> y { x.call(y) } }
-> x { x + 2 }.call(1)
-> x, y {
  x + y
}.call(3, 4)
-> x {
  -> y {
    x + y
  }
}.call(3).call(4)
p = -> n { n * 2 }
q = -> x { p.call(x) }
p.call(5)
q.call(5)
-> x { x + 5 }[6]
(1..100).each do |n|
  if (n % 15).zero?
    puts 'FizzBuzz'
  elsif (n % 3).zero?
    puts 'Fizz'
  elsif (n % 5).zero?
    puts 'Buzz'
  else
    puts n.to_s
  end
end
(1..100).map do |n|
  if (n % 15).zero?
    'FizzBuzz'
  elsif (n % 3).zero?
    'Fizz'
  elsif (n % 5).zero?
    'Buzz'
  else
    n.to_s
  end
end

def one(proc, x)
  proc[x]
end

def two(proc, x)
  proc[proc[x]]
end

def three(proc, x)
  proc[proc[proc[x]]]
end

def zero(proc, x)
  x
end

ZERO  = -> p { -> x {       x    } }
ONE   = -> p { -> x {     p[x]   } }
TWO   = -> p { -> x {   p[p[x]]  } }
THREE = -> p { -> x { p[p[p[x]]] } }

def to_integer(proc)
  proc[-> n { n + 1 }][0]
end

to_integer(ZERO)
to_integer(THREE)
FIVE    = -> p { -> x { p[p[p[p[p[x]]]]] } }
FIFTEEN = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] } }
to_integer(FIVE)
to_integer(FIFTEEN)
to_integer(HUNDRED)
success = true
if success then 'happy' else 'sad' end
success = false
if success then 'happy' else 'sad' end

def true(x, y)
  x
end

def false(x, y)
  y
end

success = :true
send(success, 'happy', 'sad')
success = :false
send(success, 'happy', 'sad')
TRUE  = -> x { -> y { x } }
FALSE = -> x { -> y { y } }

def to_boolean(proc)
  proc[true][false]
end

to_boolean(TRUE)
to_boolean(FALSE)

def if(proc, x, y)
  proc[x][y]
end

IF =
  -> b {
    -> x {
      -> y {
        b[x][y]
      }
    }
  }
IF[TRUE]['happy']['sad']
IF[FALSE]['happy']['sad']

def to_boolean(proc)
  IF[proc][true][false]
end

-> y {
  b[x][y]
}
IF =
  -> b {
    -> x {
      b[x]
    }
  }
-> x {
  b[x]
}
IF = -> b { b }

def zero?(n)
  if n == 0
    true
  else
    false
  end
end

def zero?(proc)
  proc[-> x { FALSE }][TRUE]
end

IS_ZERO = -> n { n[-> x { FALSE }][TRUE] }
to_boolean(IS_ZERO[ZERO])
to_boolean(IS_ZERO[THREE])
PAIR  = -> x { -> y { -> f { f[x][y] } } }
LEFT  = -> p { p[-> x { -> y { x } } ] }
RIGHT = -> p { p[-> x { -> y { y } } ] }
-> f { f[x][y] }
my_pair = PAIR[THREE][FIVE]
to_integer(LEFT[my_pair])
to_integer(RIGHT[my_pair])
INCREMENT = -> n { -> p { -> x { p[n[p][x]] } } }

def slide(pair)
  [pair.last, pair.last + 1]
end

slide([3, 4])
slide([8, 9])
slide([-1, 0])
slide(slide([-1, 0]))
slide(slide(slide([-1, 0])))
slide(slide(slide(slide([-1, 0]))))
slide([0, 0])
slide(slide([0, 0]))
slide(slide(slide([0, 0])))
slide(slide(slide(slide([0, 0]))))
SLIDE     = -> p { PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]] }
DECREMENT = -> n { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] }
to_integer(DECREMENT[FIVE])
to_integer(DECREMENT[FIFTEEN])
to_integer(DECREMENT[HUNDRED])
to_integer(DECREMENT[ZERO])
ADD      = -> m { -> n { n[INCREMENT][m] } }
SUBTRACT = -> m { -> n { n[DECREMENT][m] } }
MULTIPLY = -> m { -> n { n[ADD[m]][ZERO] } }
POWER    = -> m { -> n { n[MULTIPLY[m]][ONE] } }

def mod(m, n)
  if n <= m
    mod(m - n, n)
  else
    m
  end
end

def less_or_equal?(m, n)
  m - n <= 0
end

to_integer(SUBTRACT[FIVE][THREE])
to_integer(SUBTRACT[THREE][FIVE])

def less_or_equal?(m, n)
  IS_ZERO[SUBTRACT[m][n]]
end

IS_LESS_OR_EQUAL =
  -> m { -> n {
    IS_ZERO[SUBTRACT[m][n]]
  } }
to_boolean(IS_LESS_OR_EQUAL[ONE][TWO])
to_boolean(IS_LESS_OR_EQUAL[TWO][TWO])
to_boolean(IS_LESS_OR_EQUAL[THREE][TWO])

def mod(m, n)
  IF[IS_LESS_OR_EQUAL[n][m]][
    mod(SUBTRACT[m][n], n)
  ][
    m
  ]
end

MOD =
  -> m { -> n {
    IF[IS_LESS_OR_EQUAL[n][m]][
      MOD[SUBTRACT[m][n]][n]
    ][
      m
    ]
  } }
to_integer(MOD[THREE][TWO])
MOD =
  -> m { -> n {
    IF[IS_LESS_OR_EQUAL[n][m]][
      MOD[SUBTRACT[m][n]][n]
    ][
      m
    ]
  } }
MOD =
  -> m { -> n {
    IF[IS_LESS_OR_EQUAL[n][m]][
      -> x {
        MOD[SUBTRACT[m][n]][n][x]
      }
    ][
      m
    ]
  } }
to_integer(MOD[THREE][TWO])
to_integer(MOD[
     POWER[THREE][THREE]
   ][
     ADD[THREE][TWO]
   ])
Y = -> f { -> x { f[x[x]] }[-> x { f[x[x]] }] }
Z = -> f { -> x { f[-> y { x[x][y] }] }[-> x { f[-> y { x[x][y] }] }] }
MOD =
  Z[-> f { -> m { -> n {
    IF[IS_LESS_OR_EQUAL[n][m]][
      -> x {
        f[SUBTRACT[m][n]][n][x]
      }
    ][
      m
    ]
  } } }]
to_integer(MOD[THREE][TWO])
to_integer(MOD[
  POWER[THREE][THREE]
][
  ADD[THREE][TWO]
])
EMPTY     = PAIR[TRUE][TRUE]
UNSHIFT   = -> l { -> x {
              PAIR[FALSE][PAIR[x][l]]
            } }
IS_EMPTY  = LEFT
FIRST     = -> l { LEFT[RIGHT[l]] }
REST      = -> l { RIGHT[RIGHT[l]] }
my_list =
  UNSHIFT[
    UNSHIFT[
      UNSHIFT[EMPTY][THREE]
    ][TWO]
  ][ONE]
to_integer(FIRST[my_list])
to_integer(FIRST[REST[my_list]])
to_integer(FIRST[REST[REST[my_list]]])
to_boolean(IS_EMPTY[my_list])
to_boolean(IS_EMPTY[EMPTY])

def to_array(proc)
  array = []

  until to_boolean(IS_EMPTY[proc])
    array.push(FIRST[proc])
    proc = REST[proc]
  end

  array
end

to_array(my_list)
to_array(my_list).map { |p| to_integer(p) }

def range(m, n)
  if m <= n
    range(m + 1, n).unshift(m)
  else
    []
  end
end

RANGE =
  Z[-> f {
    -> m { -> n {
      IF[IS_LESS_OR_EQUAL[m][n]][
        -> x {
          UNSHIFT[f[INCREMENT[m]][n]][m][x]
        }
      ][
        EMPTY
      ]
    } }
  }]
my_range = RANGE[ONE][FIVE]
to_array(my_range).map { |p| to_integer(p) }
FOLD =
  Z[-> f {
    -> l { -> x { -> g {
      IF[IS_EMPTY[l]][
        x
      ][
        -> y {
          g[f[REST[l]][x][g]][FIRST[l]][y]
        }
      ]
    } } }
  }]
to_integer(FOLD[RANGE[ONE][FIVE]][ZERO][ADD])
to_integer(FOLD[RANGE[ONE][FIVE]][ONE][MULTIPLY])
MAP =
  -> k { -> f {
    FOLD[k][EMPTY][
      -> l { -> x { UNSHIFT[l][f[x]] } }
    ]
  } }
my_list = MAP[RANGE[ONE][FIVE]][INCREMENT]
to_array(my_list).map { |p| to_integer(p) }
TEN = MULTIPLY[TWO][FIVE]
B   = TEN
F   = INCREMENT[B]
I   = INCREMENT[F]
U   = INCREMENT[I]
ZED = INCREMENT[U]
FIZZ     = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][I]][F]
BUZZ     = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[EMPTY][ZED]][ZED]][U]][B]
FIZZBUZZ = UNSHIFT[UNSHIFT[UNSHIFT[UNSHIFT[BUZZ][ZED]][ZED]][I]][F]

def to_char(c)
  '0123456789BFiuz'.slice(to_integer(c))
end

def to_string(s)
  to_array(s).map { |c| to_char(c) }.join
end

to_char(ZED)
to_string(FIZZBUZZ)

def to_digits(n)
  previous_digits =
    if n < 10
      []
    else
      to_digits(n / 10)
    end

  previous_digits.push(n % 10)
end

DIV =
  Z[-> f { -> m { -> n {
    IF[IS_LESS_OR_EQUAL[n][m]][
      -> x {
        INCREMENT[f[SUBTRACT[m][n]][n]][x]
      }
    ][
      ZERO
    ]
  } } }]
PUSH =
  -> l {
    -> x {
      FOLD[l][UNSHIFT[EMPTY][x]][UNSHIFT]
    }
  }
TO_DIGITS =
  Z[-> f { -> n { PUSH[
    IF[IS_LESS_OR_EQUAL[n][DECREMENT[TEN]]][
      EMPTY
    ][
      -> x {
        f[DIV[n][TEN]][x]
      }
    ]
  ][MOD[n][TEN]] } }]
to_array(TO_DIGITS[FIVE]).map { |p| to_integer(p) }
to_array(TO_DIGITS[POWER[FIVE][THREE]]).map { |p| to_integer(p) }
to_string(TO_DIGITS[FIVE])
to_string(TO_DIGITS[POWER[FIVE][THREE]])
MAP[RANGE[ONE][HUNDRED]][-> n {
  IF[IS_ZERO[MOD[n][FIFTEEN]]][
    FIZZBUZZ
  ][IF[IS_ZERO[MOD[n][THREE]]][
    FIZZ
  ][IF[IS_ZERO[MOD[n][FIVE]]][
    BUZZ
  ][
    TO_DIGITS[n]
  ]]]
}]
solution =
  MAP[RANGE[ONE][HUNDRED]][-> n {
    IF[IS_ZERO[MOD[n][FIFTEEN]]][
      FIZZBUZZ
    ][IF[IS_ZERO[MOD[n][THREE]]][
      FIZZ
    ][IF[IS_ZERO[MOD[n][FIVE]]][
      BUZZ
    ][
      TO_DIGITS[n]
    ]]]
  }]
to_array(solution).each do |p|
  puts to_string(p)
end; nil
ZEROS = Z[-> f { UNSHIFT[f][ZERO] }]
to_integer(FIRST[ZEROS])
to_integer(FIRST[REST[ZEROS]])
to_integer(FIRST[REST[REST[REST[REST[REST[ZEROS]]]]]])

def to_array(l, count = nil)
  array = []

  until to_boolean(IS_EMPTY[l]) || count == 0
    array.push(FIRST[l])
    l = REST[l]
    count = count - 1 unless count.nil?
  end

  array
end

to_array(ZEROS, 5).map { |p| to_integer(p) }
to_array(ZEROS, 10).map { |p| to_integer(p) }
to_array(ZEROS, 20).map { |p| to_integer(p) }
UPWARDS_OF = Z[-> f { -> n { UNSHIFT[-> x { f[INCREMENT[n]][x] }][n] } }]
to_array(UPWARDS_OF[ZERO], 5).map { |p| to_integer(p) }
to_array(UPWARDS_OF[FIFTEEN], 20).map { |p| to_integer(p) }
MULTIPLES_OF =
  -> m {
    Z[-> f {
      -> n { UNSHIFT[-> x { f[ADD[m][n]][x] }][n] }
    }][m]
  }
to_array(MULTIPLES_OF[TWO], 10).map { |p| to_integer(p) }
to_array(MULTIPLES_OF[FIVE], 20).map { |p| to_integer(p) }
to_array(MULTIPLES_OF[THREE], 10).map { |p| to_integer(p) }
to_array(MAP[MULTIPLES_OF[THREE]][INCREMENT], 10).map { |p| to_integer(p) }
to_array(MAP[MULTIPLES_OF[THREE]][MULTIPLY[TWO]], 10).map { |p| to_integer(p) }
MULTIPLY_STREAMS =
  Z[-> f {
    -> k { -> l {
      UNSHIFT[-> x { f[REST[k]][REST[l]][x] }][MULTIPLY[FIRST[k]][FIRST[l]]]
    } }
  }]
to_array(MULTIPLY_STREAMS[UPWARDS_OF[ONE]][MULTIPLES_OF[THREE]], 10).
  map { |p| to_integer(p) }

def multiples_of(n)
  Enumerator.new do |yielder|
    value = n
    loop do
      yielder.yield(value)
      value = value + n
    end
  end
end

multiples_of_three = multiples_of(3)
multiples_of_three.next
multiples_of_three.next
multiples_of_three.next
multiples_of(3).first
multiples_of(3).take(10)
multiples_of(3).detect { |x| x > 100 }
multiples_of(3).lazy.map { |x| x * 2 }.take(10).force
multiples_of(3).lazy.map { |x| x * 2 }.select { |x| x > 100 }.take(10).force
multiples_of(3).lazy.zip(multiples_of(4)).map { |a, b| a * b }.take(10).force

def decrease(m, n)
  if n <= m
    m - n
  else
    m
  end
end

decrease(17, 5)
decrease(decrease(17, 5), 5)
decrease(decrease(decrease(17, 5), 5), 5)
decrease(decrease(decrease(decrease(17, 5), 5), 5), 5)
decrease(decrease(decrease(decrease(decrease(17, 5), 5), 5), 5), 5)
MOD =
  -> m { -> n {
    m[-> x {
      IF[IS_LESS_OR_EQUAL[n][x]][
        SUBTRACT[x][n]
      ][
        x
      ]
    }][m]
  } }
to_integer(MOD[THREE][TWO])
to_integer(MOD[
     POWER[THREE][THREE]
   ][
     ADD[THREE][TWO]
   ])
to_integer(MOD[THREE][ZERO])

def countdown(pair)
  [pair.first.unshift(pair.last), pair.last - 1]
end

countdown([[], 10])
countdown(countdown([[], 10]))
countdown(countdown(countdown([[], 10])))
countdown(countdown(countdown(countdown([[], 10]))))
COUNTDOWN = -> p { PAIR[UNSHIFT[LEFT[p]][RIGHT[p]]][DECREMENT[RIGHT[p]]] }
RANGE = -> m { -> n { LEFT[INCREMENT[SUBTRACT[n][m]][COUNTDOWN][PAIR[EMPTY][n]]] } }
to_array(RANGE[FIVE][TEN]).map { |p| to_integer(p) }

one =
  LCFunction.new(:p,
    LCFunction.new(:x,
      LCCall.new(LCVariable.new(:p), LCVariable.new(:x))
    )
  )
increment =
  LCFunction.new(:n,
    LCFunction.new(:p,
      LCFunction.new(:x,
        LCCall.new(
          LCVariable.new(:p),
          LCCall.new(
            LCCall.new(LCVariable.new(:n), LCVariable.new(:p)),
            LCVariable.new(:x)
          )
        )
      )
    )
  )
add =
  LCFunction.new(:m,
    LCFunction.new(:n,
      LCCall.new(LCCall.new(LCVariable.new(:n), increment), LCVariable.new(:m))
    )
  )

expression = LCVariable.new(:x)
expression.replace(:x, LCFunction.new(:y, LCVariable.new(:y)))
expression.replace(:z, LCFunction.new(:y, LCVariable.new(:y)))
expression =
  LCCall.new(
    LCCall.new(
      LCCall.new(
        LCVariable.new(:a),
        LCVariable.new(:b)
      ),
      LCVariable.new(:c)
    ),
    LCVariable.new(:b)
  )
expression.replace(:a, LCVariable.new(:x))
expression.replace(:b, LCFunction.new(:x, LCVariable.new(:x)))
expression =
  LCFunction.new(:y,
    LCCall.new(LCVariable.new(:x), LCVariable.new(:y))
  )
expression.replace(:x, LCVariable.new(:z))
expression.replace(:y, LCVariable.new(:z))
expression =
  LCCall.new(
    LCCall.new(LCVariable.new(:x), LCVariable.new(:y)),
    LCFunction.new(:y, LCCall.new(LCVariable.new(:y), LCVariable.new(:x)))
  )
expression.replace(:x, LCVariable.new(:z))
expression.replace(:y, LCVariable.new(:z))
expression =
  LCFunction.new(:x,
    LCCall.new(LCVariable.new(:x), LCVariable.new(:y))
  )
replacement = LCCall.new(LCVariable.new(:z), LCVariable.new(:x))
expression.replace(:y, replacement)

function =
  LCFunction.new(:x,
    LCFunction.new(:y,
      LCCall.new(LCVariable.new(:x), LCVariable.new(:y))
    )
  )
argument = LCFunction.new(:z, LCVariable.new(:z))
function.call(argument)

expression = LCCall.new(LCCall.new(add, one), one)
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
inc, zero = LCVariable.new(:inc), LCVariable.new(:zero)
expression = LCCall.new(LCCall.new(expression, inc), zero)
while expression.reducible?
  puts expression
  expression = expression.reduce
end; puts expression
require 'treetop'
Treetop.load('lambda_calculus')
parse_tree = LambdaCalculusParser.new.parse('-> x { x[x] }[-> y { y }]')
expression = parse_tree.to_ast
expression.reduce
