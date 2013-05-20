6 * -9
(6 * -9) < 0
(1000 * -5) < 0
(1 * -1) < 0

Sign::POSITIVE * Sign::POSITIVE
Sign::NEGATIVE * Sign::ZERO
Sign::POSITIVE * Sign::NEGATIVE

6.sign
-9.sign
6.sign * -9.sign

def calculate(x, y, z)
  (x * y) * (x * z)
end

calculate(3, -5, 0)
calculate(Sign::POSITIVE, Sign::NEGATIVE, Sign::ZERO)
(6 * -9).sign == (6.sign * -9.sign)
(100 * 0).sign == (100.sign * 0.sign)
calculate(1, -2, -3).sign == calculate(1.sign, -2.sign, -3.sign)

Sign::POSITIVE + Sign::POSITIVE
Sign::NEGATIVE + Sign::ZERO
Sign::NEGATIVE + Sign::POSITIVE
Sign::POSITIVE + Sign::UNKNOWN
Sign::UNKNOWN + Sign::ZERO
Sign::POSITIVE + Sign::NEGATIVE + Sign::NEGATIVE

(Sign::POSITIVE + Sign::NEGATIVE) * Sign::ZERO + Sign::POSITIVE
(10 + 3).sign == (10.sign + 3.sign)
(-5 + 0).sign == (-5.sign + 0.sign)
(6 + -9).sign == (6.sign + -9.sign)
(6 + -9).sign
6.sign + -9.sign

Sign::POSITIVE <= Sign::POSITIVE
Sign::POSITIVE <= Sign::UNKNOWN
Sign::POSITIVE <= Sign::NEGATIVE
(6 * -9).sign <= (6.sign * -9.sign)
(-5 + 0).sign <= (-5.sign + 0.sign)
(6 + -9).sign <= (6.sign + -9.sign)

def sum_of_squares(x, y)
  (x * x) + (y * y)
end

inputs = Sign::NEGATIVE, Sign::ZERO, Sign::POSITIVE
outputs = inputs.product(inputs).map { |x, y| sum_of_squares(x, y) }
outputs.uniq
expression = Add.new(Variable.new(:x), Number.new(1))
expression.evaluate({ x: Number.new(2) })
statement = Assign.new(:y, Number.new(3))
statement.evaluate({ x: Number.new(1) })

Add.new(Number.new(1), Number.new(2)).evaluate({})
Add.new(Number.new(1), Boolean.new(true)).evaluate({})

Add.new(Number.new(1), Number.new(2)).type
Add.new(Number.new(1), Boolean.new(true)).type
LessThan.new(Number.new(1), Number.new(2)).type
LessThan.new(Number.new(1), Boolean.new(true)).type
bad_expression = Add.new(Number.new(true), Number.new(1))
bad_expression.type
bad_expression.evaluate({})

expression = Add.new(Variable.new(:x), Variable.new(:y))
expression.type({})
expression.type({ x: Type::NUMBER, y: Type::NUMBER })
expression.type({ x: Type::NUMBER, y: Type::BOOLEAN })

If.new(
  LessThan.new(Number.new(1), Number.new(2)), DoNothing.new, DoNothing.new
).type({})
If.new(
  Add.new(Number.new(1), Number.new(2)), DoNothing.new, DoNothing.new
).type({})
While.new(Variable.new(:x), DoNothing.new).type({ x: Type::BOOLEAN })
While.new(Variable.new(:x), DoNothing.new).type({ x: Type::NUMBER })

statement =
  While.new(
    LessThan.new(Variable.new(:x), Number.new(5)),
    Assign.new(:x, Add.new(Variable.new(:x), Number.new(3)))
  )
statement.type({})
statement.type({ x: Type::NUMBER })
statement.type({ x: Type::BOOLEAN })
statement =
  Sequence.new(
    Assign.new(:x, Number.new(0)),
    While.new(
      Boolean.new(true),
      Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
    )
  )
statement.type({ x: Type::NUMBER })
statement.evaluate({})
statement = Sequence.new(statement, Assign.new(:x, Boolean.new(true)))
statement.type({ x: Type::NUMBER })
statement =
  Sequence.new(
    If.new(
      Variable.new(:b),
      Assign.new(:x, Number.new(6)),
      Assign.new(:x, Boolean.new(true))
    ),
    Sequence.new(
      If.new(
        Variable.new(:b),
        Assign.new(:y, Variable.new(:x)),
        Assign.new(:y, Number.new(1))
      ),
      Assign.new(:z, Add.new(Variable.new(:y), Number.new(1)))
    )
  )
statement.evaluate({ b: Boolean.new(true) })
statement.evaluate({ b: Boolean.new(false) })
statement.type({})
context = { b: Type::BOOLEAN, y: Type::NUMBER, z: Type::NUMBER }
statement.type(context)
statement.type(context.merge({ x: Type::NUMBER }))
statement.type(context.merge({ x: Type::BOOLEAN }))
statement = Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
statement.type({ x: Type::NUMBER })
statement.evaluate({})
