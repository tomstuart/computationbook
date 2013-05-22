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
      subject { Multiply.new(Number.new(2), Number.new(3)) }

      it { should be_reducible }
      it { should reduce_to Number.new(6) }
    end

    describe 'less than' do
      subject { LessThan.new(Number.new(1), Number.new(2)) }

      it { should be_reducible }
      it { should reduce_to Boolean.new(true) }
    end
  end
end
