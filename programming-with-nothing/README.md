Programming with Nothing
========================

This chapter includes an implementation of FizzBuzz written with just procs:

```irb
$ cd programming-with-nothing
$ irb -I.
>> require 'programming-with-nothing'
fizzbuzz.rb:13: warning: already initialized constant TRUE
fizzbuzz.rb:14: warning: already initialized constant FALSE
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
