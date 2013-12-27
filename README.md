# Compo

**Compo** is a library providing mixins and base classes for setting up
composite objects.

It implements something similar to the Gang of Four Composite pattern, but with
the difference that children are identified in their parents by an *ID*,
such as the index or hash key, that the child is aware of at all times.

Compo was designed for the purpose of creating models whose natural composite
structure can be expressed as URLs made from their recursive ID trails.

## Installation

Add this line to your application's Gemfile:

    gem 'compo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compo

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
