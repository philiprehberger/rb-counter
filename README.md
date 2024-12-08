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

### Delete

```ruby
counter = Philiprehberger::Counter.new(%w[a a b c])
counter.delete('a')  # => 2 (removes key entirely)
counter.delete('z')  # => nil (key not present)
```

### Min and Max

```ruby
counter = Philiprehberger::Counter.new(%w[a b a c a b])
counter.max_count  # => ["a", 3]
counter.min_count  # => ["c", 1]
```

### JSON Serialization

```ruby
counter = Philiprehberger::Counter.new(%w[a b a])
json = counter.to_json              # => '{"a":2,"b":1}'
restored = Philiprehberger::Counter.from_json(json)
restored['a']                        # => 2
```

### Weighted Sampling

```ruby
counter = Philiprehberger::Counter.new(%w[a a a b])
counter.sample      # => "a" (weighted by count)
counter.sample(3)   # => ["a", "a", "b"] (array of weighted samples)
```

### Keys and Values

```ruby
counter = Philiprehberger::Counter.new(%w[a b a])
counter.keys    # => ["a", "b"]
counter.values  # => [2, 1]
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
| `#delete(key)` | Remove a key entirely, returns count or nil |
| `#max_count` | Key-count pair with highest count |
| `#min_count` | Key-count pair with lowest count |
| `#to_json` | Serialize counter to JSON string |
| `.from_json(str)` | Deserialize counter from JSON string |
| `#sample(n)` | Weighted random sample based on counts |
| `#keys` | Return all tracked keys |
| `#values` | Return all count values |
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
