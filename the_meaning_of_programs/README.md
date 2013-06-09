The Meaning of Programs
=======================

[This chapter](http://computationbook.com/sample) includes Ruby implementations of the semantics of a toy programming language (“Simple”) written in three contrasting styles: [small-step operational](small_step), [big-step operational](big_step) and [denotational](denotational):

```irb
$ bundle exec irb -I.
>> require 'the_meaning_of_programs'
=> true
>> expression = LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(5))
=> «x + 1 < 5»
>> expression.reduce(x: Number.new(3))
=> «3 + 1 < 5»
>> expression.evaluate(x: Number.new(3))
=> «true»
>> expression.to_ruby
=> "-> e { (-> e { (-> e { e[:x] }).call(e) + (-> e { 1 }).call(e) }).call(e) < (-> e { 5 }).call(e) }"
>> eval(expression.to_ruby)
=> #<Proc (lambda)>
>> eval(expression.to_ruby).call(x: 3)
=> true
```

[@mudge](https://github.com/mudge) contributed an alternative denotational semantics which uses JavaScript as the denotation language:

```irb
>> expression.to_javascript
=> "function (e) { return (function (e) { return (function (e) { return e[\"x\"]; }(e)) + (function (e) { return 1; }(e)); }(e)) < (function (e) { return 5; }(e)); }"
>> require 'execjs'
=> true
>> ExecJS.eval("#{expression.to_javascript}({ x: 3 })")
=> true
```

In the book, the `Machine` class is introduced as a way of evaluating *expressions* by repeatedly applying Simple’s small-step semantics, and later redefined as a way of evaluating *statements*. The example code can only define one `Machine` class, which has caused confusion (e.g. [#1](https://github.com/tomstuart/computationbook/issues/1), [#2](https://github.com/tomstuart/computationbook/issues/2)) among people who expect to be able to use a single class to evaluate both expressions and statements. To clarify the situation, this repository contains two classes, `ExpressionMachine` and `StatementMachine`, which are able to evaluate expressions and statements respectively:

```irb
>> ExpressionMachine.new(LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(5)), { x: Number.new(3) }).run
x + 1 < 5
3 + 1 < 5
4 < 5
true
=> nil
>> StatementMachine.new(Sequence.new(Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))), Assign.new(:y, Multiply.new(Variable.new(:x), Number.new(2)))), { x: Number.new(3) }).run
x = x + 1; y = x * 2, {:x=>«3»}
x = 3 + 1; y = x * 2, {:x=>«3»}
x = 4; y = x * 2, {:x=>«3»}
do-nothing; y = x * 2, {:x=>«4»}
y = x * 2, {:x=>«4»}
y = 4 * 2, {:x=>«4»}
y = 8, {:x=>«4»}
do-nothing, {:x=>«4», :y=>«8»}
=> nil
```

The `Machine` class should still work, albeit with a warning:

```irb
>> Machine.new(LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(5)), { x: Number.new(3) }).run
WARNING: Automatically using ExpressionMachine instead of Machine. See the_meaning_of_programs/README.md for details.
x + 1 < 5
3 + 1 < 5
4 < 5
true
=> nil
```

There’s also a Treetop parser for Simple:

```irb
>> require 'treetop'
=> true
>> Treetop.load('the_meaning_of_programs/parser/simple')
=> SimpleParser
>> parse_tree = SimpleParser.new.parse('if (x + 1 < 5) { x = x * 2 } else { x = x + 1 }')
=> SyntaxNode+If1+If0 offset=0, "...} else { x = x + 1 }" (to_ast,condition,consequence,alternative):
  SyntaxNode offset=0, "if ("
  SyntaxNode+LessThan1+LessThan0 offset=4, "x + 1 < 5" (to_ast,left,right):
    SyntaxNode+Add1+Add0 offset=4, "x + 1" (to_ast,left,right):
      SyntaxNode+Variable0 offset=4, "x" (to_ast):
        SyntaxNode offset=4, "x"
      SyntaxNode offset=5, " + "
      SyntaxNode+Number0 offset=8, "1" (to_ast):
        SyntaxNode offset=8, "1"
    SyntaxNode offset=9, " < "
    SyntaxNode+Number0 offset=12, "5" (to_ast):
      SyntaxNode offset=12, "5"
  SyntaxNode offset=13, ") { "
  SyntaxNode+Assign1+Assign0 offset=17, "x = x * 2" (to_ast,name,expression):
    SyntaxNode offset=17, "x":
      SyntaxNode offset=17, "x"
    SyntaxNode offset=18, " = "
    SyntaxNode+Multiply1+Multiply0 offset=21, "x * 2" (to_ast,left,right):
      SyntaxNode+Variable0 offset=21, "x" (to_ast):
        SyntaxNode offset=21, "x"
      SyntaxNode offset=22, " * "
      SyntaxNode+Number0 offset=25, "2" (to_ast):
        SyntaxNode offset=25, "2"
  SyntaxNode offset=26, " } else { "
  SyntaxNode+Assign1+Assign0 offset=36, "x = x + 1" (to_ast,name,expression):
    SyntaxNode offset=36, "x":
      SyntaxNode offset=36, "x"
    SyntaxNode offset=37, " = "
    SyntaxNode+Add1+Add0 offset=40, "x + 1" (to_ast,left,right):
      SyntaxNode+Variable0 offset=40, "x" (to_ast):
        SyntaxNode offset=40, "x"
      SyntaxNode offset=41, " + "
      SyntaxNode+Number0 offset=44, "1" (to_ast):
        SyntaxNode offset=44, "1"
  SyntaxNode offset=45, " }"
>> statement = parse_tree.to_ast
=> «if (x + 1 < 5) { x = x * 2 } else { x = x + 1 }»
>> statement.reduce(x: Number.new(3))
=> [«if (3 + 1 < 5) { x = x * 2 } else { x = x + 1 }», {:x=>«3»}]
>> statement.evaluate(x: Number.new(3))
=> {:x=>«6»}
```
