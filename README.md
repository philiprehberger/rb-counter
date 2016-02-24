# philiprehberger-counter

[![Tests](https://github.com/philiprehberger/rb-counter/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-counter/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-counter.svg)](https://rubygems.org/gems/philiprehberger-counter)
[![License](https://img.shields.io/github/license/philiprehberger/rb-counter)](LICENSE)

Frequency counter with most-common, merge, and percentage operations

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-counter"
```

Or install directly:

```bash
gem install philiprehberger-counter
```

## Usage

```ruby
require 'philiprehberger/counter'

counter = Philiprehberger::Counter.new(%w[a b a c a b])
counter['a']            # => 3
counter.most_common(2)  # => [["a", 3], ["b", 2]]
counter.total           # => 6
counter.percentage('a') # => 50.0
```

### Increment

```ruby
counter = Philiprehberger::Counter.new
counter.increment('x')
counter.increment('x', 5)
counter['x']  # => 6
```

### Merge and Subtract

```ruby
a = Philiprehberger::Counter.new(%w[x x y])
b = Philiprehberger::Counter.new(%w[x z])
merged = a.merge(b)
merged['x']  # => 3
```

### Enumerable

```ruby
counter = Philiprehberger::Counter.new(%w[a b a])
counter.map { |key, count| "#{key}: #{count}" }
# => ["a: 2", "b: 1"]
```

## API

| Method | Description |
|--------|-------------|
| `Counter.new(enumerable)` | Create a counter from an enumerable |
| `#[key]` | Get count for a key |
| `#increment(key, n)` | Increment count for a key |
| `#most_common(n)` | Return n most common elements |
| `#least_common(n)` | Return n least common elements |
| `#total` | Sum of all counts |
| `#merge(other)` | Merge two counters |
| `#subtract(other)` | Subtract another counter |
| `#percentage(key)` | Percentage of key relative to total |
| `#to_h` | Convert to a plain hash |
| `#size` | Number of unique keys |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

MIT
