require_relative '../syntax'
require_relative 'expression_machine'
require_relative 'statement_machine'

# Chapter 2 defines the Machine class to work with expressions, then redefines it to work with
# statements. In this repository, these two definitions are both made available under separate
# names: ExpressionMachine is a virtual machine which evaluates expressions by repeatedly
# applying the small-step semantics, while StatementMachine does the same for statements.
#
# The below implementation of Machine is provided as a backwards-compatibility layer so that
# Machine.new continues to work for those who are following along with the examples in the book.
class Machine
  def self.new(syntax, *args)
    machine_class =
      case syntax
      when Add, Boolean, LessThan, Multiply, Number, Variable
        ExpressionMachine
      when Assign, DoNothing, If, Sequence, While
        StatementMachine
      else
        raise "Unrecognized syntax: #{syntax.inspect}"
      end

    $stderr.puts "WARNING: Automatically using #{machine_class} instead of #{self}. See the the_meaning_of_programs/README.md for details."

    machine_class.new(syntax, *args)
  end
end
