require_relative '../syntax'
require_relative 'expression_machine'
require_relative 'statement_machine'

# This class is provided as a backwards-compatibility layer so that Machine.new continues to work.
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
