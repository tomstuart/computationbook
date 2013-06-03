require_relative 'spec_helper'
require_relative '../big_step'

describe 'the big-step operational semantics of Simple' do
  describe 'expressions' do
    describe 'a variable' do
      subject { Variable.new(:x) }
      let(:value) { double }
      let(:environment) { { x: value } }

      it { should evaluate_to(value).within(environment) }
    end

    describe 'a number' do
      subject(:itself) { Number.new(double) }

      it { should evaluate_to itself }
    end

    describe 'booleans' do
      describe 'true' do
        subject(:itself) { Boolean.new(true) }

        it { should evaluate_to itself }
      end

      describe 'false' do
        subject(:itself) { Boolean.new(false) }

        it { should evaluate_to itself }
      end
    end

    describe 'addition' do
      context 'without reducible subexpressions' do
        subject { Add.new(Number.new(1), Number.new(2)) }

        it { should evaluate_to Number.new(3) }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { Add.new(Add.new(Number.new(1), Number.new(2)), Number.new(3)) }

          it { should evaluate_to Number.new(6) }
        end

        context 'on the right' do
          subject { Add.new(Number.new(1), Add.new(Number.new(2), Number.new(3))) }

          it { should evaluate_to Number.new(6) }
        end

        context 'on both sides' do
          subject { Add.new(Add.new(Number.new(1), Number.new(2)), Add.new(Number.new(3), Number.new(4))) }

          it { should evaluate_to Number.new(10) }
        end
      end
    end

    describe 'multiplication' do
      context 'without reducible subexpressions' do
        subject { Multiply.new(Number.new(2), Number.new(3)) }

        it { should evaluate_to Number.new(6) }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { Multiply.new(Multiply.new(Number.new(2), Number.new(3)), Number.new(4)) }

          it { should evaluate_to Number.new(24) }
        end

        context 'on the right' do
          subject { Multiply.new(Number.new(2), Multiply.new(Number.new(3), Number.new(4))) }

          it { should evaluate_to Number.new(24) }
        end

        context 'on both sides' do
          subject { Multiply.new(Multiply.new(Number.new(2), Number.new(3)), Multiply.new(Number.new(4), Number.new(5))) }

          it { should evaluate_to Number.new(120) }
        end
      end
    end

    describe 'less than' do
      context 'without reducible subexpressions' do
        subject { LessThan.new(Number.new(1), Number.new(2)) }

        it { should evaluate_to Boolean.new(true) }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { LessThan.new(Add.new(Number.new(2), Number.new(3)), Number.new(4)) }

          it { should evaluate_to Boolean.new(false) }
        end

        context 'on the right' do
          subject { LessThan.new(Number.new(1), Add.new(Number.new(2), Number.new(3))) }

          it { should evaluate_to Boolean.new(true) }
        end

        context 'on both sides' do
          subject { LessThan.new(Add.new(Number.new(1), Number.new(5)), Multiply.new(Number.new(2), Number.new(3))) }

          it { should evaluate_to Boolean.new(false) }
        end
      end
    end
  end
end
