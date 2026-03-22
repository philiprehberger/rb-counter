# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Counter do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '.new' do
    it 'creates an empty counter' do
      counter = described_class.new
      expect(counter.total).to eq(0)
    end

    it 'counts elements from an array' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter['a']).to eq(3)
      expect(counter['b']).to eq(2)
      expect(counter['c']).to eq(1)
    end

    it 'raises Error for non-enumerable' do
      expect { described_class.new(123) }.to raise_error(described_class::Error)
    end
  end

  describe '#[]' do
    it 'returns count for existing key' do
      counter = described_class.new(%w[a a b])
      expect(counter['a']).to eq(2)
    end

    it 'returns 0 for missing key' do
      counter = described_class.new
      expect(counter['missing']).to eq(0)
    end
  end

  describe '#increment' do
    it 'increments by 1 by default' do
      counter = described_class.new
      counter.increment('a')
      expect(counter['a']).to eq(1)
    end

    it 'increments by a custom amount' do
      counter = described_class.new
      counter.increment('a', 5)
      expect(counter['a']).to eq(5)
    end
  end

  describe '#most_common' do
    it 'returns all elements sorted by frequency' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter.most_common).to eq([['a', 3], ['b', 2], ['c', 1]])
    end

    it 'returns top n elements' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter.most_common(2)).to eq([['a', 3], ['b', 2]])
    end
  end

  describe '#least_common' do
    it 'returns all elements sorted by frequency ascending' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter.least_common).to eq([['c', 1], ['b', 2], ['a', 3]])
    end

    it 'returns bottom n elements' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter.least_common(1)).to eq([['c', 1]])
    end
  end

  describe '#total' do
    it 'returns sum of all counts' do
      counter = described_class.new(%w[a b a])
      expect(counter.total).to eq(3)
    end

    it 'returns 0 for empty counter' do
      expect(described_class.new.total).to eq(0)
    end
  end

  describe '#merge' do
    it 'merges two counters' do
      a = described_class.new(%w[x x y])
      b = described_class.new(%w[x z])
      result = a.merge(b)
      expect(result['x']).to eq(3)
      expect(result['y']).to eq(1)
      expect(result['z']).to eq(1)
    end

    it 'raises Error for non-counter' do
      counter = described_class.new
      expect { counter.merge('not a counter') }.to raise_error(described_class::Error)
    end
  end

  describe '#subtract' do
    it 'subtracts two counters' do
      a = described_class.new(%w[x x x y])
      b = described_class.new(%w[x y y])
      result = a.subtract(b)
      expect(result['x']).to eq(2)
      expect(result['y']).to eq(-1)
    end
  end

  describe '#percentage' do
    it 'calculates percentage' do
      counter = described_class.new(%w[a a b b b])
      expect(counter.percentage('a')).to eq(40.0)
      expect(counter.percentage('b')).to eq(60.0)
    end

    it 'returns 0.0 for empty counter' do
      expect(described_class.new.percentage('a')).to eq(0.0)
    end
  end

  describe '#to_h' do
    it 'returns a hash of counts' do
      counter = described_class.new(%w[a b a])
      expect(counter.to_h).to eq({ 'a' => 2, 'b' => 1 })
    end
  end

  describe 'Enumerable' do
    it 'supports map' do
      counter = described_class.new(%w[a b])
      keys = counter.map { |k, _| k }
      expect(keys).to contain_exactly('a', 'b')
    end
  end

  describe '#size' do
    it 'returns number of unique keys' do
      counter = described_class.new(%w[a b a])
      expect(counter.size).to eq(2)
    end
  end
end
