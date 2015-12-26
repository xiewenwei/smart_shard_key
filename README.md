# SmartShardKey

smart_shard_key is a tiny tool for generating smart_id and extracting shard_key from Smart ID.

Smart ID is good way for id of sharding db/table. It is a little big long and composed of timestamp, shard_id and sequence.Smart ID keeps order of ID and contains many information. smart_shard_key is a tiny tool for generating smart_id and extracting information from Smart ID.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smart_shard_key'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smart_shard_key

## Usage

Include SmartShardKey module in your model. It will extend a series of methods to your model as follow.

```
shard_id_of_key(key)
shard_id_of_id(id)
generate_id(key, sequence = nil, timestamp = nil)
split_id(id)
```

For example.

```
class HugeModel
  include SmartShardKey
end

model = HugeModel.new(user_id: xxx)

model.id = HugeModel.generate_id(model.user_id)

shard_id = HugeModel.shard_id_of_key(xxx)

shard_id = HugeModel.shard_id_of_id(xxx)

timestamp, shard_id, sequence = HugeModel.split_id(xxx)

```

It is very simple. Read the comment and the code when you have any question.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiewenwei/smart_shard_key. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

