require_relative 'spec_helper'
require_relative '../syntax'

describe 'the syntax of Simple' do
  describe 'expressions' do
    describe 'a variable' do
      subject { Variable.new(:x) }

      its(:name) { should == :x }
      it { should look_like 'x' }
    end

    describe 'a number' do
      subject { Number.new(42) }

      its(:value) { should == 42 }
      it { should look_like '42' }
    end

    describe 'booleans' do
      describe 'true' do
        subject { Boolean.new(true) }

        its(:value) { should == true }
        it { should look_like 'true' }
      end

      describe 'false' do
        subject { Boolean.new(false) }

        its(:value) { should == false }
        it { should look_like 'false' }
      end
    end

    describe 'addition' do
      subject { Add.new(Number.new(1), Number.new(2)) }

      its(:left) { should == Number.new(1) }
      its(:right) { should == Number.new(2) }
      it { should look_like '1 + 2' }
    end

    describe 'multiplication' do
      subject { Multiply.new(Number.new(2), Number.new(3)) }

      its(:left) { should == Number.new(2) }
      its(:right) { should == Number.new(3) }
      it { should look_like '2 * 3' }
    end

    describe 'less than' do
      subject { LessThan.new(Number.new(1), Number.new(2)) }

      its(:left) { should == Number.new(1) }
      its(:right) { should == Number.new(2) }
      it { should look_like '1 < 2' }
    end
  end
end
