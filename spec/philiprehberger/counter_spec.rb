# frozen_string_literal: true

require 'json'
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

    it 'returns 0 for empty counter' do
      expect(described_class.new.size).to eq(0)
    end
  end

  describe '#increment with negative values' do
    it 'decrements when given a negative amount' do
      counter = described_class.new(%w[a a a])
      counter.increment('a', -1)
      expect(counter['a']).to eq(2)
    end

    it 'allows count to go below zero' do
      counter = described_class.new
      counter.increment('x', -5)
      expect(counter['x']).to eq(-5)
    end

    it 'increments by zero leaving count unchanged' do
      counter = described_class.new(%w[a])
      counter.increment('a', 0)
      expect(counter['a']).to eq(1)
    end
  end

  describe '#subtract edge cases' do
    it 'returns empty counter when subtracting from empty' do
      a = described_class.new
      b = described_class.new(%w[x])
      result = a.subtract(b)
      expect(result['x']).to eq(-1)
    end

    it 'raises Error for non-counter argument' do
      counter = described_class.new
      expect { counter.subtract('nope') }.to raise_error(described_class::Error)
    end

    it 'returns copy when subtracting empty counter' do
      a = described_class.new(%w[x y])
      b = described_class.new
      result = a.subtract(b)
      expect(result['x']).to eq(1)
      expect(result['y']).to eq(1)
    end
  end

  describe '#merge edge cases' do
    it 'merges two empty counters' do
      a = described_class.new
      b = described_class.new
      result = a.merge(b)
      expect(result.total).to eq(0)
      expect(result.size).to eq(0)
    end

    it 'merges into empty counter' do
      a = described_class.new
      b = described_class.new(%w[x x])
      result = a.merge(b)
      expect(result['x']).to eq(2)
    end
  end

  describe '#to_h' do
    it 'returns empty hash for empty counter' do
      expect(described_class.new.to_h).to eq({})
    end

    it 'returns a defensive copy' do
      counter = described_class.new(%w[a])
      hash = counter.to_h
      hash['a'] = 999
      expect(counter['a']).to eq(1)
    end
  end

  describe '#percentage edge cases' do
    it 'returns 100.0 for single-key counter' do
      counter = described_class.new(%w[a a a])
      expect(counter.percentage('a')).to eq(100.0)
    end

    it 'returns 0.0 for missing key in non-empty counter' do
      counter = described_class.new(%w[a b])
      expect(counter.percentage('z')).to eq(0.0)
    end
  end

  describe '#most_common edge cases' do
    it 'returns empty array for empty counter' do
      expect(described_class.new.most_common).to eq([])
    end

    it 'returns empty array when n is 0' do
      counter = described_class.new(%w[a b])
      expect(counter.most_common(0)).to eq([])
    end
  end

  describe '#least_common edge cases' do
    it 'returns empty array for empty counter' do
      expect(described_class.new.least_common).to eq([])
    end

    it 'returns all when n exceeds size' do
      counter = described_class.new(%w[a])
      expect(counter.least_common(5)).to eq([['a', 1]])
    end
  end

  describe 'Enumerable advanced' do
    it 'supports select' do
      counter = described_class.new(%w[a a b c c c])
      result = counter.select { |_, count| count > 1 }
      expect(result).to contain_exactly(['a', 2], ['c', 3])
    end

    it 'supports min_by' do
      counter = described_class.new(%w[a a b c c c])
      expect(counter.min_by { |_, count| count }).to eq(['b', 1])
    end

    it 'supports count' do
      counter = described_class.new(%w[a b c])
      expect(counter.count).to eq(3)
    end
  end

  describe 'initialization with various enumerables' do
    it 'counts from a range' do
      counter = described_class.new([1, 2, 2, 3, 3, 3])
      expect(counter[3]).to eq(3)
    end

    it 'counts symbols' do
      counter = described_class.new(%i[a b a])
      expect(counter[:a]).to eq(2)
    end

    it 'counts mixed types' do
      counter = described_class.new([1, 'a', 1, :b, 'a'])
      expect(counter[1]).to eq(2)
      expect(counter['a']).to eq(2)
      expect(counter[:b]).to eq(1)
    end
  end

  describe '#decrement' do
    it 'decrements by 1 by default' do
      counter = described_class.new(%w[a a a])
      counter.decrement('a')
      expect(counter['a']).to eq(2)
    end

    it 'decrements by a custom amount' do
      counter = described_class.new(%w[a a a a a])
      counter.decrement('a', 3)
      expect(counter['a']).to eq(2)
    end

    it 'floors at zero' do
      counter = described_class.new(%w[a])
      counter.decrement('a', 5)
      expect(counter['a']).to eq(0)
    end

    it 'floors at zero for missing key' do
      counter = described_class.new
      counter.decrement('x')
      expect(counter['x']).to eq(0)
    end
  end

  describe '#reset' do
    it 'resets a specific key' do
      counter = described_class.new(%w[a b c])
      counter.reset('a')
      expect(counter['a']).to eq(0)
      expect(counter['b']).to eq(1)
    end

    it 'clears all counts when no key given' do
      counter = described_class.new(%w[a b c])
      counter.reset
      expect(counter.total).to eq(0)
      expect(counter.size).to eq(0)
    end

    it 'does nothing for missing key' do
      counter = described_class.new(%w[a])
      counter.reset('z')
      expect(counter['a']).to eq(1)
    end
  end

  describe '#update' do
    it 'updates from a hash' do
      counter = described_class.new(%w[a])
      counter.update({ 'a' => 3, 'b' => 2 })
      expect(counter['a']).to eq(4)
      expect(counter['b']).to eq(2)
    end

    it 'updates from an enumerable' do
      counter = described_class.new
      counter.update(%w[x y x])
      expect(counter['x']).to eq(2)
      expect(counter['y']).to eq(1)
    end

    it 'returns self for chaining' do
      counter = described_class.new
      result = counter.update(%w[a])
      expect(result).to be(counter)
    end

    it 'raises Error for invalid argument' do
      counter = described_class.new
      expect { counter.update(123) }.to raise_error(described_class::Error)
    end
  end

  describe '#delete' do
    it 'removes a key entirely and returns its count' do
      counter = described_class.new(%w[a a b])
      result = counter.delete('a')
      expect(result).to eq(2)
      expect(counter.size).to eq(1)
      expect(counter['a']).to eq(0)
    end

    it 'returns nil for a missing key' do
      counter = described_class.new(%w[a])
      expect(counter.delete('z')).to be_nil
    end

    it 'works on empty counter' do
      counter = described_class.new
      expect(counter.delete('x')).to be_nil
    end
  end

  describe '#max_count' do
    it 'returns the key-count pair with highest count' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter.max_count).to eq(['a', 3])
    end

    it 'returns nil for empty counter' do
      expect(described_class.new.max_count).to be_nil
    end

    it 'returns the single entry for single-key counter' do
      counter = described_class.new(%w[x x])
      expect(counter.max_count).to eq(['x', 2])
    end
  end

  describe '#min_count' do
    it 'returns the key-count pair with lowest count' do
      counter = described_class.new(%w[a b a c a b])
      expect(counter.min_count).to eq(['c', 1])
    end

    it 'returns nil for empty counter' do
      expect(described_class.new.min_count).to be_nil
    end

    it 'returns the single entry for single-key counter' do
      counter = described_class.new(%w[x])
      expect(counter.min_count).to eq(['x', 1])
    end
  end

  describe '#to_json / .from_json' do
    it 'serializes to JSON string' do
      counter = described_class.new(%w[a b a])
      json = counter.to_json
      parsed = JSON.parse(json)
      expect(parsed).to eq({ 'a' => 2, 'b' => 1 })
    end

    it 'deserializes from JSON string' do
      counter = described_class.from_json('{"x":3,"y":1}')
      expect(counter['x']).to eq(3)
      expect(counter['y']).to eq(1)
    end

    it 'roundtrips correctly' do
      original = described_class.new(%w[a b a c])
      json = original.to_json
      restored = described_class.from_json(json)
      expect(restored.to_h).to eq(original.to_h)
    end

    it 'handles empty counter roundtrip' do
      original = described_class.new
      json = original.to_json
      restored = described_class.from_json(json)
      expect(restored.size).to eq(0)
    end
  end

  describe '#sample' do
    it 'returns a single item by default' do
      counter = described_class.new(%w[a a a])
      expect(counter.sample).to eq('a')
    end

    it 'returns an array when n > 1' do
      counter = described_class.new(%w[a a a])
      result = counter.sample(3)
      expect(result).to be_an(Array)
      expect(result.length).to eq(3)
      expect(result).to all(eq('a'))
    end

    it 'returns nil for empty counter with n=1' do
      expect(described_class.new.sample).to be_nil
    end

    it 'returns empty array for empty counter with n>1' do
      expect(described_class.new.sample(3)).to eq([])
    end

    it 'only samples from keys with positive counts' do
      counter = described_class.new(%w[a a a])
      counter.increment('b', -1)
      100.times do
        expect(counter.sample).to eq('a')
      end
    end
  end

  describe '#keys' do
    it 'returns all tracked keys' do
      counter = described_class.new(%w[a b c])
      expect(counter.keys).to contain_exactly('a', 'b', 'c')
    end

    it 'returns empty array for empty counter' do
      expect(described_class.new.keys).to eq([])
    end
  end

  describe '#values' do
    it 'returns all count values' do
      counter = described_class.new(%w[a a b])
      expect(counter.values).to contain_exactly(2, 1)
    end

    it 'returns empty array for empty counter' do
      expect(described_class.new.values).to eq([])
    end
  end

  describe '#filter_by_count' do
    it 'filters by minimum count' do
      counter = described_class.new(%w[a a a b b c])
      result = counter.filter_by_count(min: 2)
      expect(result['a']).to eq(3)
      expect(result['b']).to eq(2)
      expect(result['c']).to eq(0)
    end

    it 'filters by maximum count' do
      counter = described_class.new(%w[a a a b b c])
      result = counter.filter_by_count(max: 2)
      expect(result['b']).to eq(2)
      expect(result['c']).to eq(1)
      expect(result['a']).to eq(0)
    end

    it 'filters by both min and max' do
      counter = described_class.new(%w[a a a b b c])
      result = counter.filter_by_count(min: 2, max: 2)
      expect(result['b']).to eq(2)
      expect(result['a']).to eq(0)
      expect(result['c']).to eq(0)
    end

    it 'returns empty counter when nothing matches' do
      counter = described_class.new(%w[a b])
      result = counter.filter_by_count(min: 5)
      expect(result.size).to eq(0)
    end
  end
end
