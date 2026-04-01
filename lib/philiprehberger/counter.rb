# frozen_string_literal: true

require_relative 'counter/version'

module Philiprehberger
  class Counter
    include Enumerable

    class Error < StandardError; end

    # Create a new Counter from an enumerable
    #
    # @param enumerable [Enumerable, nil] initial elements to count
    def initialize(enumerable = nil)
      @counts = Hash.new(0)
      return unless enumerable

      raise Error, 'argument must be Enumerable' unless enumerable.is_a?(Enumerable)

      enumerable.each { |item| @counts[item] += 1 }
    end

    # Get count for a key
    #
    # @param key [Object]
    # @return [Integer]
    def [](key)
      @counts[key]
    end

    # Increment count for a key
    #
    # @param key [Object]
    # @param n [Integer] amount to increment
    # @return [Integer] new count
    def increment(key, n = 1)
      @counts[key] += n
    end

    # Decrement count for a key, floored at zero
    #
    # @param key [Object]
    # @param n [Integer] amount to decrement
    # @return [Integer] new count
    def decrement(key, n = 1)
      @counts[key] = [(@counts[key] - n), 0].max
    end

    # Reset counts — clear a specific key or all counts
    #
    # @param key [Object, nil] key to reset, or nil to clear all
    # @return [void]
    def reset(key = nil)
      if key.nil?
        @counts.clear
      else
        @counts.delete(key)
      end
    end

    # Batch update counts from a Hash or Enumerable
    #
    # @param data [Hash, Enumerable] Hash of key => count, or Enumerable of items to count
    # @return [self]
    def update(data)
      case data
      when Hash
        data.each { |key, count| @counts[key] += count }
      when Enumerable
        data.each { |item| @counts[item] += 1 }
      else
        raise Error, 'argument must be a Hash or Enumerable'
      end
      self
    end

    # Filter entries by count range
    #
    # @param min [Integer, nil] minimum count (inclusive)
    # @param max [Integer, nil] maximum count (inclusive)
    # @return [Counter] new counter with filtered entries
    def filter_by_count(min: nil, max: nil)
      result = Counter.new
      each do |key, count|
        next if min && count < min
        next if max && count > max

        result.increment(key, count)
      end
      result
    end

    # Return the n most common elements and their counts
    #
    # @param n [Integer, nil] number of elements to return
    # @return [Array<Array>] array of [key, count] pairs
    def most_common(n = nil)
      sorted = @counts.sort_by { |_, count| -count }
      n ? sorted.first(n) : sorted
    end

    # Return the n least common elements and their counts
    #
    # @param n [Integer, nil] number of elements to return
    # @return [Array<Array>] array of [key, count] pairs
    def least_common(n = nil)
      sorted = @counts.sort_by { |_, count| count }
      n ? sorted.first(n) : sorted
    end

    # Total of all counts
    #
    # @return [Integer]
    def total
      @counts.values.sum
    end

    # Merge another counter into this one
    #
    # @param other [Counter]
    # @return [Counter] new counter with merged counts
    def merge(other)
      raise Error, 'argument must be a Counter' unless other.is_a?(Counter)

      result = Counter.new
      each { |key, count| result.increment(key, count) }
      other.each { |key, count| result.increment(key, count) }
      result
    end

    # Subtract another counter from this one
    #
    # @param other [Counter]
    # @return [Counter] new counter with subtracted counts
    def subtract(other)
      raise Error, 'argument must be a Counter' unless other.is_a?(Counter)

      result = Counter.new
      each { |key, count| result.increment(key, count) }
      other.each { |key, count| result.increment(key, -count) }
      result
    end

    # Get the percentage of a key relative to total
    #
    # @param key [Object]
    # @return [Float]
    def percentage(key)
      return 0.0 if total.zero?

      (@counts[key].to_f / total * 100)
    end

    # Convert to a plain hash
    #
    # @return [Hash]
    def to_h
      @counts.dup
    end

    # Iterate over key-count pairs
    #
    # @yield [key, count]
    def each(&)
      @counts.each(&)
    end

    # Number of unique keys
    #
    # @return [Integer]
    def size
      @counts.size
    end
  end
end
