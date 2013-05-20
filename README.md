Understanding Computation example code
======================================

This is the example code for [Understanding Computation](http://computationbook.com/), an O’Reilly book about computation theory. (Here’s [a sample chapter](http://cdn.oreillystatic.com/oreilly/booksamplers/9781449329273_sampler.pdf).)

Right now it’s a pretty rough dump of code from the book. Each chapter has its own directory:

* Chapter 2: [The Meaning of Programs](the-meaning-of-programs)
* Chapter 3: [The Simplest Computers](the-simplest-computers)
* Chapter 4: [Just Add Power](just-add-power)
* Chapter 5: [The Ultimate Machine](the-ultimate-machine)
* Chapter 6: [Programming with Nothing](programming-with-nothing)
* Chapter 7: [Universality is Everywhere](universality-is-everywhere)
* Chapter 8: [Impossible Programs](impossible-programs)
* Chapter 9: [Programming in Toyland](programming-in-toyland)

Each directory contains definitions of the classes implemented in that chapter, as well as a file named after the chapter (e.g. [`just-add-power/just-add-power.rb`](just-add-power/just-add-power.rb)) that can be `require`d to load all the code for that chapter.

For example:

```irb
$ irb -I.
>> require 'universality-is-everywhere/universality-is-everywhere'
=> true
>> identity = SKICall.new(SKICall.new(S, K), SKICall.new(K, K))
=> S[K][K[K]]
>> x = SKISymbol.new(:x)
=> x
>> expression = SKICall.new(identity, x)
=> S[K][K[K]][x]
>> while expression.reducible?; puts expression; expression = expression.reduce; end; expression
S[K][K[K]][x]
K[x][K[K][x]]
K[x][K]
=> x
```

If you run `bundle install` to install [Treetop](http://treetop.rubyforge.org/), you can try out the parsers:

```irb
$ bundle exec irb -I.
>> require 'treetop'
=> true
>> Treetop.load('the-meaning-of-programs/simple')
=> SimpleParser
>> require 'the-meaning-of-programs/the-meaning-of-programs'
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
>> Treetop.load('programming-with-nothing/lambda_calculus')
=> LambdaCalculusParser
>> require 'programming-with-nothing/programming-with-nothing'
=> true
>> two = LambdaCalculusParser.new.parse('-> p { -> x { p[p[x]] } }').to_ast
=> -> p { -> x { p[p[x]] } }
>> require 'universality-is-everywhere/universality-is-everywhere'
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
