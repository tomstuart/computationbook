require_relative 'spec_helper'
require_relative '../small_step'

describe 'the small-step operational semantics of Simple' do
  describe 'expressions' do
    describe 'a variable' do
      subject { Variable.new(:x) }
      let(:value) { double }
      let(:environment) { { x: value } }

      it { should be_reducible }
      it { should reduce_to(value).within(environment) }
    end

    describe 'a number' do
      subject { Number.new(42) }

      it { should_not be_reducible }
    end

    describe 'booleans' do
      describe 'true' do
        subject { Boolean.new(true) }

        it { should_not be_reducible }
      end

      describe 'false' do
        subject { Boolean.new(false) }

        it { should_not be_reducible }
      end
    end

    describe 'addition' do
      context 'without reducible subexpressions' do
        subject { Add.new(Number.new(1), Number.new(2)) }

        it { should be_reducible }
        it { should reduce_to Number.new(3) }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { Add.new(Add.new(Number.new(1), Number.new(2)), Number.new(3)) }

          it { should be_reducible }
          it { should reduce_to Add.new(Number.new(3), Number.new(3)) }
        end

        context 'on the right' do
          subject { Add.new(Number.new(1), Add.new(Number.new(2), Number.new(3))) }

          it { should be_reducible }
          it { should reduce_to Add.new(Number.new(1), Number.new(5)) }
        end

        context 'on both sides' do
          subject { Add.new(Add.new(Number.new(1), Number.new(2)), Add.new(Number.new(3), Number.new(4))) }

          it { should be_reducible }
          it { should reduce_to Add.new(Number.new(3), Add.new(Number.new(3), Number.new(4))) }
        end
      end
    end

    describe 'multiplication' do
      context 'without reducible subexpressions' do
        subject { Multiply.new(Number.new(2), Number.new(3)) }

        it { should be_reducible }
        it { should reduce_to Number.new(6) }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { Multiply.new(Multiply.new(Number.new(2), Number.new(3)), Number.new(4)) }

          it { should be_reducible }
          it { should reduce_to Multiply.new(Number.new(6), Number.new(4)) }
        end

        context 'on the right' do
          subject { Multiply.new(Number.new(2), Multiply.new(Number.new(3), Number.new(4))) }

          it { should be_reducible }
          it { should reduce_to Multiply.new(Number.new(2), Number.new(12)) }
        end

        context 'on both sides' do
          subject { Multiply.new(Multiply.new(Number.new(2), Number.new(3)), Multiply.new(Number.new(4), Number.new(5))) }

          it { should be_reducible }
          it { should reduce_to Multiply.new(Number.new(6), Multiply.new(Number.new(4), Number.new(5))) }
        end
      end
    end

    describe 'less than' do
      context 'without reducible subexpressions' do
        subject { LessThan.new(Number.new(1), Number.new(2)) }

        it { should be_reducible }
        it { should reduce_to Boolean.new(true) }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { LessThan.new(Add.new(Number.new(2), Number.new(3)), Number.new(4)) }

          it { should be_reducible }
          it { should reduce_to LessThan.new(Number.new(5), Number.new(4)) }
        end

        context 'on the right' do
          subject { LessThan.new(Number.new(1), Add.new(Number.new(2), Number.new(3))) }

          it { should be_reducible }
          it { should reduce_to LessThan.new(Number.new(1), Number.new(5)) }
        end

        context 'on both sides' do
          subject { LessThan.new(Add.new(Number.new(1), Number.new(5)), Multiply.new(Number.new(2), Number.new(3))) }

          it { should be_reducible }
          it { should reduce_to LessThan.new(Number.new(6), Multiply.new(Number.new(2), Number.new(3))) }
        end
      end
    end
  end

  describe 'statements' do
    describe 'do-nothing' do
      subject { DoNothing.new }

      it { should_not be_reducible }
    end

    describe 'assignment' do
      let(:environment) { { x: Number.new(1), y: Number.new(2) } }

      context 'without a reducible subexpression' do
        subject { Assign.new(:x, Number.new(5)) }

        it { should be_reducible }
        it { should reduce_to([DoNothing.new, { x: Number.new(5), y: Number.new(2) }]).within(environment) }
      end

      context 'with a reducible subexpression' do
        subject { Assign.new(:x, Add.new(Number.new(2), Number.new(3))) }

        it { should be_reducible }
        it { should reduce_to([Assign.new(:x, Number.new(5)), environment]).within(environment) }
      end
    end

    describe 'sequence' do
      let(:environment) { { y: Number.new(3) } }

      context 'without reducible substatements' do
        subject { Sequence.new(DoNothing.new, DoNothing.new) }

        it { should be_reducible }
        it { should reduce_to([DoNothing.new, environment]).within(environment) }
      end

      context 'with a reducible substatement' do
        context 'in first position' do
          subject { Sequence.new(Assign.new(:x, Number.new(1)), DoNothing.new) }

          it { should be_reducible }
          it { should reduce_to([Sequence.new(DoNothing.new, DoNothing.new), { x: Number.new(1), y: Number.new(3) }]).within(environment) }
        end

        context 'in second position' do
          subject { Sequence.new(DoNothing.new, Assign.new(:x, Number.new(2))) }

          it { should be_reducible }
          it { should reduce_to([Assign.new(:x, Number.new(2)), { y: Number.new(3) }]).within(environment) }
        end

        context 'in both positions' do
          subject { Sequence.new(Assign.new(:x, Number.new(1)), Assign.new(:x, Number.new(2))) }

          it { should be_reducible }
          it { should reduce_to([Sequence.new(DoNothing.new, Assign.new(:x, Number.new(2))), { x: Number.new(1), y: Number.new(3) }]).within(environment) }
        end
      end
    end

    describe 'if' do
      let(:environment) { { x: Number.new(1), y: Number.new(2) } }

      context 'without a reducible subexpression' do
        subject { If.new(Boolean.new(false), Assign.new(:x, Number.new(3)), Assign.new(:y, Number.new(3))) }

        it { should be_reducible }
        it { should reduce_to([Assign.new(:y, Number.new(3)), environment]).within(environment) }
      end

      context 'with a reducible subexpression' do
        subject { If.new(LessThan.new(Number.new(3), Number.new(4)), Assign.new(:x, Number.new(3)), Assign.new(:y, Number.new(3))) }

        it { should be_reducible }
        it { should reduce_to([If.new(Boolean.new(true), Assign.new(:x, Number.new(3)), Assign.new(:y, Number.new(3))), environment]).within(environment) }
      end
    end

    describe 'while' do
      subject { While.new(LessThan.new(Variable.new(:x), Number.new(5)), Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))) }
      let(:environment) { { x: Number.new(1) } }

      it { should be_reducible }
      it { should reduce_to([If.new(LessThan.new(Variable.new(:x), Number.new(5)), Sequence.new(Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))), While.new(LessThan.new(Variable.new(:x), Number.new(5)), Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))))), DoNothing.new), environment]).within(environment) }
    end
  end
end
