# philiprehberger-counter

[![Tests](https://github.com/philiprehberger/rb-counter/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-counter/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-counter.svg)](https://rubygems.org/gems/philiprehberger-counter)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-counter)](https://github.com/philiprehberger/rb-counter/commits/main)

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
require "philiprehberger/counter"

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

### Decrement and Reset

```ruby
counter = Philiprehberger::Counter.new(%w[a a a b])
counter.decrement('a')     # => 2
counter.decrement('a', 2)  # => 0
counter.reset('b')         # removes 'b'
counter.reset              # clears all
```

### Batch Update

```ruby
counter = Philiprehberger::Counter.new
counter.update(%w[x y x z])         # count from enumerable
counter.update({ 'x' => 10 })       # add from hash
counter['x']                         # => 12
```

### Filtering

```ruby
counter = Philiprehberger::Counter.new(%w[a a a b b c])
frequent = counter.filter_by_count(min: 2)
frequent.to_h  # => {"a" => 3, "b" => 2}
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
| `#decrement(key, n)` | Decrement count for a key, floored at zero |
| `#reset(key)` | Reset a specific key or clear all counts |
| `#update(data)` | Batch update from a Hash or Enumerable |
| `#filter_by_count(min:, max:)` | Filter entries by count range |
| `#to_h` | Convert to a plain hash |
| `#size` | Number of unique keys |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-counter)

🐛 [Report issues](https://github.com/philiprehberger/rb-counter/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-counter/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
