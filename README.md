Understanding Computation example code
======================================

This is the example code for [Understanding Computation](http://computationbook.com/), an O’Reilly book about computation theory. (Here’s [a sample chapter](http://cdn.oreillystatic.com/oreilly/booksamplers/9781449329273_sampler.pdf).) Ruby 1.9 or 2.0 is required.

Right now it’s a pretty rough dump of code from the book. Each chapter has its own directory:

* Chapter 2: [The Meaning of Programs](the_meaning_of_programs)
* Chapter 3: [The Simplest Computers](the_simplest_computers)
* Chapter 4: [Just Add Power](just_add_power)
* Chapter 5: [The Ultimate Machine](the_ultimate_machine)
* Chapter 6: [Programming with Nothing](programming_with_nothing)
* Chapter 7: [Universality is Everywhere](universality_is_everywhere)
* Chapter 8: [Impossible Programs](impossible_programs)
* Chapter 9: [Programming in Toyland](programming_in_toyland)

Each directory contains definitions of the classes implemented in that chapter. There’s also a file named after each chapter (e.g. [`just_add_power.rb`](just_add_power.rb)) that can be `require`d to load all the code for that chapter.

For example:

```irb
$ irb -I.
>> require 'universality_is_everywhere'
=> true
>> identity = SKICall.new(SKICall.new(S, K), SKICall.new(K, K))
=> S[K][K[K]]
>> x = SKISymbol.new(:x)
=> x
>> expression = SKICall.new(identity, x)
=> S[K][K[K]][x]
>> while expression.reducible?; puts expression; expression = expression.reduce; end; puts expression
S[K][K[K]][x]
K[x][K[K][x]]
K[x][K]
x
=> nil
```

If you run `bundle install` to install [Treetop](http://treetop.rubyforge.org/), you can try out the parsers:

```irb
$ bundle exec irb -I.
>> require 'treetop'
=> true
>> Treetop.load('the_meaning_of_programs/simple')
=> SimpleParser
>> require 'the_meaning_of_programs'
=> true
>> program = SimpleParser.new.parse('while (x < 5) { x = x * 3 }').to_ast
=> «while (x < 5) { x = x * 3 }»
>> program.reduce(x: Number.new(3))
=> [«if (x < 5) { x = x * 3; while (x < 5) { x = x * 3 } } else { do-nothing }», {:x=>«3»}]
>> program.evaluate(x: Number.new(3))
=> {:x=>«9»}
>> program.to_ruby
=> "-> e { while (-> e { (-> e { e[:x] }).call(e) < (-> e { 5 }).call(e) }).call(e); e = (-> e { e.merge({ :x => (-> e { (-> e { e[:x] }).call(e) * (-> e { 3 }).call(e) }).call(e) }) }).call(e); end; e }"
>> eval(program.to_ruby).call(x: 3)
=> {:x=>9}
```

```irb
$ bundle exec irb -I.
>> require 'treetop'
=> true
>> Treetop.load('programming_with_nothing/lambda_calculus')
=> LambdaCalculusParser
>> require 'programming_with_nothing'
=> true
>> two = LambdaCalculusParser.new.parse('-> p { -> x { p[p[x]] } }').to_ast
=> -> p { -> x { p[p[x]] } }
>> require 'universality_is_everywhere'
=> true
>> two.to_ski
=> S[S[K[S]][S[K[K]][I]]][S[S[K[S]][S[K[K]][I]]][K[I]]]
>> two.to_ski.to_iota
=> ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ]]]]][ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ]]]]][ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ]]]]
>> inc, zero = SKISymbol.new(:inc), SKISymbol.new(:zero)
=> [inc, zero]
>> expression = SKICall.new(SKICall.new(two.to_ski.to_iota, inc), zero)
=> ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ]]]]][ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]]]][ɩ[ɩ[ɩ[ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ[ɩ[ɩ]]]]][ɩ[ɩ]]]][ɩ[ɩ[ɩ[ɩ]]][ɩ[ɩ]]]][inc][zero]
>> expression = expression.reduce while expression.reducible?
=> nil
>> expression
=> inc[inc[zero]]
```

If you have any questions, please get in touch via [Twitter](http://twitter.com/tomstuart) or [email](mailto:tom@codon.com). If you find any bugs or other programs with the code, please [open an issue](https://github.com/tomstuart/computationbook/issues/new).
