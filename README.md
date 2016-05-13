# VCR Assistant

VCR Assistant is a tidy approach to managing VCR cassettes and setup/teardown logic. Currently it's built for use within RSpec v3 (but patches for other test frameworks are certainly welcome).

It will automatically name your VCR cassette for you (based on the current example file name and description). You can also configure your assistant to automatically perform setup and teardown code. Here's a quick example for use with Stripe's test sandbox:

```ruby
class StripeAssistant
  def initialize(vcr_cassette)
    @vcr_cassette = vcr_cassette
  end

  def setup
    # Clear out Stripe data at the beginning of a recording
    # to ensure the sandbox environment is consistent.
    Stripe::Customer.all.each &:delete
    Stripe::Coupon.all.each &:delete
    Stripe::Plan.all.each &:delete
  end
end

VCRAssistant.assistant = lambda { |label, vcr_cassette|
  StripeAssistant.new vcr_cassette
}

it 'automatically clears Stripe before tests' do |example|
  assisted_cassette(example) do |assistant|
    # assistant is an instance of StripeAssistant
    # and the `setup` method has already been called.

    # run test code with external HTTP calls
    # assert expectations

    # if assistant responded to a teardown method, that
    # would automatically be invoked at the end of this block.
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vcr_assistant', '~> 0.2.0', :group => :test
```

To have the `assisted_cassette` helper to be available in all specs, you can require `'vcr_assistant/rspec'` either in your Gemfile:

```ruby
gem 'vcr_assistant', '~> 0.2.0',
  :group   => :test,
  :require => 'vcr_assistant/rspec'
```

Or in your `spec_helper.rb` or `rails_helper.rb` file:

```ruby
require 'vcr_assistant/rspec'
```

## Usage

Instead of calling `VCR.use_cassette`, instead use either the `assisted_cassette` helper method or `VCRAssistant::Cassette.call(example)` directly. Either way, you need to pass in the current RSpec

```ruby
it 'should make external HTTP calls' do |example|
  assisted_cassette example do |assistant|
    # make API calls

    # assert expectations
  end
end

# or

it 'should make external HTTP calls' do |example|
  VCRAssistant::Cassette.call example do |assistant|
    # make API calls

    # assert expectations
  end
end
```

You can also pass through options for that specific VCR call as the last argument in both `assisted_cassette` and `VCRAssistant::Cassette.call`:

```ruby
assisted_cassette example, :record => :new_episodes do |assistant|
  # ...
end

# or, if specifying a label:
assisted_cassette example, :default, :record => :new_episodes do |assistant|
  # ...
end
```

### Custom assistants

A standard assistant won't do anything much - you'll just get the advantage of automatically named cassettes. To have a custom assistant, you need to change the value of `VCRAssistant.assistant` to something that responds to `call` - perhaps a Proc or lambda - and then returns an object.

If this object responds to `setup`, that will be called before the cassette block is invoked, and same with `teardown` after the block. The arguments sent to the assistant generator are the label and the underlying VCR cassette. The label is useful to distinguish between different uses of VCR - it's the optional second argument for `assisted_cassette` / `VCRAssistant::Cassette.call`. If it's not provided, it has the value `:default`.

```ruby
VCRAssistant.assistant = lambda { |label, vcr_cassette|
  case label
  when :stripe
    StripeAssistant.new vcr_cassette
  when :paypal
    PayPalAssistant.new vcr_cassette
  else
    nil # An assistant object is not essential
  end
}
```

You may want to add further functionality to your assistant - such as preparing regularly used data. For the example of Stripe, you may want to prepare customer or plan objects in some tests:

```ruby
# This is example code - it does not exist in VCR Assistant.
class StripeAssistant
  def initialize(vcr_cassette)
    @vcr_cassette = vcr_cassette
  end

  def setup
    Stripe::Customer.all.each &:delete
    Stripe::Coupon.all.each &:delete
    Stripe::Plan.all.each &:delete
  end

  def customer(email)
    Stripe::Customer.create :email => email
  end
end

# and then in a test:
it 'should make external HTTP calls' do |example|
  assisted_cassette example do |assistant|
    customer = assistant.customer 'pat@example.com'

    # run tests that may involve the new customer object

    # assert expectations
  end
end
```

### Custom cassette file names

The default approach to naming cassettes is to take the spec's file name (minus the _spec.rb suffix) as a folder name, and the specific example's description as the file name (lowercased and with underscores instead of spaces). Thus, a cassette in testing_stripe_spec.rb within an example description `'creates subscriptions'` would be named `testing_stripe/creates_subscriptions.yml`.

If you'd like to have your own name generator, you can change `VCRAssistant.namer` to be a callable object that returns the appropriate file name as a string.

```ruby
VCRAssistant.namer = lambda { |example|
  # Just use the spec's file name. Useless if you have
  # more than one cassette in any given file.
  example.metadata[:file_path].gsub(/_spec\.rb$/, '')
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pat/vcr_assistant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Licence

Copyright (c) 2016, VCR Assistant is developed and maintained by Pat Allan, and is released under the open MIT Licence.
