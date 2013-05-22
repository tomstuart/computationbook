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
      subject { Add.new(Number.new(1), Number.new(2)) }

      it { should be_denoted_by '-> e { (-> e { 1 }).call(e) + (-> e { 2 }).call(e) }' }
      it { should mean 3 }
    end

    describe 'multiplication' do
      subject { Multiply.new(Number.new(2), Number.new(3)) }

      it { should be_denoted_by '-> e { (-> e { 2 }).call(e) * (-> e { 3 }).call(e) }' }
      it { should mean 6 }
    end

    describe 'less than' do
      subject { LessThan.new(Number.new(1), Number.new(2)) }

      it { should be_denoted_by '-> e { (-> e { 1 }).call(e) < (-> e { 2 }).call(e) }' }
      it { should mean true }
    end
  end
end
