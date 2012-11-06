# traitor [![Build Status](https://secure.travis-ci.org/txus/traitor.png)](http://travis-ci.org/txus/traitor)

Traitor is a basic implementation of
[Traits](http://en.wikipedia.org/wiki/Trait_(computer_programming)) (duh) for Ruby 2.0.

Also, it might be the only library in the world that represents a non-optional
use case for refinements. `</troll>`

## Installation

Add this line to your application's Gemfile:

    rvm install ruby-2.0.0-preview1
    gem 'traitor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traits

## Behavior reusability through Traits

Traits are like Ruby modules in the sense that they can be used to define
composable units of behavior, but they are not included hierarchically. They
are truly composable, meaning that are pieces that *must* either fit
perfectly or the host object must provide a way for them to do it, normally
resolving conflicts by explicitly redefining the conflicting methods.

Say we have a `Colorable` trait:

```ruby
Colorable = Trait.new do
  attr_accessor :color

  def ==(other)
    other.color == color
  end
end
```

And a `Shapeable` trait:

```ruby
Shapeable = Trait.new do
  attr_accessor :sides

  def ==(other)
    other.sides == sides
  end
end
```

Now we would like an object composed of those two traits:

```ruby
class Rectangle
  uses Shapeable
  uses Colorable
end
```

This obviously doesn't work -- if we try to call #== on a `Rectangle`, it
doesn't know which implementation should it call. `Colorable` or `Shapeable`?
See the error:

```ruby
Rectangle.new == Rectangle.new
# TraitConflict: Conflicting methods: #==
```

Traits have no hierarchy, so no one prevails over the others. The only way to
use both traits is to provide an explicit conflict resolution:

```ruby
class Rectangle
  uses Shapeable
  uses Colorable

  def ==(other)
    colorable_equal = trait_send(Colorable, :==, other)
    shapeable_equal = trait_send(Shapeable, :==, other)
    colorable_equal && shapeable_equal
  end
end
```

Now we can use `#==` safely because we **control** how conflicts are resolved.
Note that we have access to either implementation via `trait_send`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Who's this

This was made by [Josep M. Bach (Txus)](http://txustice.me) under the MIT
license. I'm [@txustice](http://twitter.com/txustice) on twitter (where you
should probably follow me!).
