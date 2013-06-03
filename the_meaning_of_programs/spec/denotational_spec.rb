require_relative 'spec_helper'
require_relative '../denotational'

describe 'the denotational semantics of Simple' do
  describe 'expressions' do
    describe 'a variable' do
      subject { Variable.new(:x) }
      let(:value) { double }
      let(:environment) { { x: value } }

      it { should be_denoted_by '-> e { e[:x] }' }
      it { should mean(value).within(environment) }
    end

    describe 'a number' do
      subject { Number.new(42) }

      it { should be_denoted_by '-> e { 42 }' }
      it { should mean 42 }
    end

    describe 'booleans' do
      describe 'true' do
        subject { Boolean.new(true) }

        it { should be_denoted_by '-> e { true }' }
        it { should mean true }
      end

      describe 'false' do
        subject { Boolean.new(false) }

        it { should be_denoted_by '-> e { false }' }
        it { should mean false }
      end
    end

    describe 'addition' do
      context 'without reducible subexpressions' do
        subject { Add.new(Number.new(1), Number.new(2)) }

        it { should be_denoted_by '-> e { (-> e { 1 }).call(e) + (-> e { 2 }).call(e) }' }
        it { should mean 3 }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { Add.new(Add.new(Number.new(1), Number.new(2)), Number.new(3)) }

          it { should be_denoted_by '-> e { (-> e { (-> e { 1 }).call(e) + (-> e { 2 }).call(e) }).call(e) + (-> e { 3 }).call(e) }' }
          it { should mean 6 }
        end

        context 'on the right' do
          subject { Add.new(Number.new(1), Add.new(Number.new(2), Number.new(3))) }

          it { should be_denoted_by '-> e { (-> e { 1 }).call(e) + (-> e { (-> e { 2 }).call(e) + (-> e { 3 }).call(e) }).call(e) }' }
          it { should mean 6 }
        end

        context 'on both sides' do
          subject { Add.new(Add.new(Number.new(1), Number.new(2)), Add.new(Number.new(3), Number.new(4))) }

          it { should be_denoted_by '-> e { (-> e { (-> e { 1 }).call(e) + (-> e { 2 }).call(e) }).call(e) + (-> e { (-> e { 3 }).call(e) + (-> e { 4 }).call(e) }).call(e) }' }
          it { should mean 10 }
        end
      end
    end

    describe 'multiplication' do
      context 'without reducible subexpressions' do
        subject { Multiply.new(Number.new(2), Number.new(3)) }

        it { should be_denoted_by '-> e { (-> e { 2 }).call(e) * (-> e { 3 }).call(e) }' }
        it { should mean 6 }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { Multiply.new(Multiply.new(Number.new(2), Number.new(3)), Number.new(4)) }

          it { should be_denoted_by '-> e { (-> e { (-> e { 2 }).call(e) * (-> e { 3 }).call(e) }).call(e) * (-> e { 4 }).call(e) }' }
          it { should mean 24 }
        end

        context 'on the right' do
          subject { Multiply.new(Number.new(2), Multiply.new(Number.new(3), Number.new(4))) }

          it { should be_denoted_by '-> e { (-> e { 2 }).call(e) * (-> e { (-> e { 3 }).call(e) * (-> e { 4 }).call(e) }).call(e) }' }
          it { should mean 24 }
        end

        context 'on both sides' do
          subject { Multiply.new(Multiply.new(Number.new(2), Number.new(3)), Multiply.new(Number.new(4), Number.new(5))) }

          it { should be_denoted_by '-> e { (-> e { (-> e { 2 }).call(e) * (-> e { 3 }).call(e) }).call(e) * (-> e { (-> e { 4 }).call(e) * (-> e { 5 }).call(e) }).call(e) }' }
          it { should mean 120 }
        end
      end
    end

    describe 'less than' do
      context 'without reducible subexpressions' do
        subject { LessThan.new(Number.new(1), Number.new(2)) }

        it { should be_denoted_by '-> e { (-> e { 1 }).call(e) < (-> e { 2 }).call(e) }' }
        it { should mean true }
      end

      context 'with a reducible subexpression' do
        context 'on the left' do
          subject { LessThan.new(Add.new(Number.new(2), Number.new(3)), Number.new(4)) }

          it { should be_denoted_by '-> e { (-> e { (-> e { 2 }).call(e) + (-> e { 3 }).call(e) }).call(e) < (-> e { 4 }).call(e) }' }
          it { should mean false }
        end

        context 'on the right' do
          subject { LessThan.new(Number.new(1), Add.new(Number.new(2), Number.new(3))) }

          it { should be_denoted_by '-> e { (-> e { 1 }).call(e) < (-> e { (-> e { 2 }).call(e) + (-> e { 3 }).call(e) }).call(e) }' }
          it { should mean true }
        end

        context 'on both sides' do
          subject { LessThan.new(Add.new(Number.new(1), Number.new(5)), Multiply.new(Number.new(2), Number.new(3))) }

          it { should be_denoted_by '-> e { (-> e { (-> e { 1 }).call(e) + (-> e { 5 }).call(e) }).call(e) < (-> e { (-> e { 2 }).call(e) * (-> e { 3 }).call(e) }).call(e) }' }
          it { should mean false }
        end
      end
    end
  end
end
