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
end
