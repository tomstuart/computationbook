require_relative 'spec_helper'
require_relative '../parser'
require_relative '../syntax'

describe 'the Simple parser' do
  describe 'expressions' do
    describe 'numbers' do
      specify { '0'.should parse_as Number.new(0) }
      specify { '42'.should parse_as Number.new(42) }
    end

    describe 'variables' do
      specify { 'x'.should parse_as Variable.new(:x) }
      specify { 'y'.should parse_as Variable.new(:y) }
      specify { 'trueness'.should parse_as Variable.new(:trueness) }
      specify { 'falsehood'.should parse_as Variable.new(:falsehood) }
    end

    describe 'less than' do
      specify { 'x < 5'.should parse_as LessThan.new(Variable.new(:x), Number.new(5)) }
    end

    describe 'multiplication' do
      specify { '1 * 2'.should parse_as Multiply.new(Number.new(1), Number.new(2)) }
      specify { '1 * 2 * 3'.should parse_as Multiply.new(Number.new(1), Multiply.new(Number.new(2), Number.new(3))) }
    end
  end

  describe 'statements' do
    describe 'assignment' do
      specify { 'x = 42'.should parse_as Assign.new(:x, Number.new(42)) }
      specify { 'y = 6 * 7'.should parse_as Assign.new(:y, Multiply.new(Number.new(6), Number.new(7))) }
    end

    describe 'while' do
      specify { 'while (x < 5) { x = x * 3 }'.should parse_as While.new(LessThan.new(Variable.new(:x), Number.new(5)), Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))) }
    end
  end
end
