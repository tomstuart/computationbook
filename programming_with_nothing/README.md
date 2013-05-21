Programming with Nothing
========================

This chapter includes an implementation of FizzBuzz written with just procs:

```irb
$ irb -I.
>> require 'programming_with_nothing'
=> true
>> MULTIPLY[THREE][FIVE]
=> #<Proc (lambda)>
>> to_integer(MULTIPLY[THREE][FIVE])
=> 15
>> to_array(RANGE[FIVE][TEN]).map { |p| to_integer(p) }
=> [5, 6, 7, 8, 9, 10]
>> to_array(MAP[RANGE[FIVE][TEN]][MULTIPLY[THREE]]).map { |p| to_integer(p) }
=> [15, 18, 21, 24, 27, 30]
>> to_integer(FOLD[RANGE[FIVE][TEN]][ZERO][ADD])
=> 45
>> results = to_array(SOLUTION)
=> [#<Proc (lambda)>, #<Proc (lambda)>, #<Proc (lambda)>, #<Proc (lambda)>, #<Proc (lambda)>, …]
>> results.each do |p| puts to_string(p) end; nil
1
2
Fizz
4
Buzz
Fizz
7
⋮
94
Buzz
Fizz
97
98
Fizz
Buzz
=> nil
```

Watch [this video](http://rubymanor.org/3/videos/programming_with_nothing/) for more explanation.

There’s also an implementation of the call-by-value small-step operational semantics of the lambda calculus, along with a parser for Ruby-style lambda calculus expressions:

```irb
$ bundle exec irb -I.
>> require 'treetop'
=> true
>> Treetop.load('programming_with_nothing/lambda_calculus/lambda_calculus')
=> LambdaCalculusParser
>> require 'programming_with_nothing'
=> true
>> one = LambdaCalculusParser.new.parse('-> p { -> x { p[x] } }').to_ast
=> -> p { -> x { p[x] } }
>> increment = LambdaCalculusParser.new.parse('-> n { -> p { -> x { p[n[p][x]] } } }').to_ast
=> -> n { -> p { -> x { p[n[p][x]] } } }
>> add = LambdaCalculusParser.new.parse("-> m { -> n { n[#{increment}][m] } }").to_ast
=> -> m { -> n { n[-> n { -> p { -> x { p[n[p][x]] } } }][m] } }
>> expression = LCCall.new(LCCall.new(add, one), one)
=> -> m { -> n { n[-> n { -> p { -> x { p[n[p][x]] } } }][m] } }[-> p { -> x { p[x] } }][-> p { -> x { p[x] } }]
>> while expression.reducible?; puts expression; expression = expression.reduce; end; puts expression
-> m { -> n { n[-> n { -> p { -> x { p[n[p][x]] } } }][m] } }[-> p { -> x { p[x] } }][-> p { -> x { p[x] } }]
-> n { n[-> n { -> p { -> x { p[n[p][x]] } } }][-> p { -> x { p[x] } }] }[-> p { -> x { p[x] } }]
-> p { -> x { p[x] } }[-> n { -> p { -> x { p[n[p][x]] } } }][-> p { -> x { p[x] } }]
-> x { -> n { -> p { -> x { p[n[p][x]] } } }[x] }[-> p { -> x { p[x] } }]
-> n { -> p { -> x { p[n[p][x]] } } }[-> p { -> x { p[x] } }]
-> p { -> x { p[-> p { -> x { p[x] } }[p][x]] } }
=> nil
>> inc, zero = LCVariable.new(:inc), LCVariable.new(:zero)
=> [inc, zero]
>> expression = LCCall.new(LCCall.new(expression, inc), zero)
=> -> p { -> x { p[-> p { -> x { p[x] } }[p][x]] } }[inc][zero]
>> while expression.reducible?; puts expression; expression = expression.reduce; end; puts expression
-> p { -> x { p[-> p { -> x { p[x] } }[p][x]] } }[inc][zero]
-> x { inc[-> p { -> x { p[x] } }[inc][x]] }[zero]
inc[-> p { -> x { p[x] } }[inc][zero]]
inc[-> x { inc[x] }[zero]]
inc[inc[zero]]
=> nil
```
