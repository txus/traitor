require 'minitest/autorun'
require 'traitor'

Colorable = Trait.new do
  attr_accessor :color
  def ==(other)
    other.color == color
  end
end

Shapeable = Trait.new do
  attr_accessor :sides

  def side_length; 10; end

  def perimeter
    sides * side_length
  end

  def ==(other)
    other.sides == sides
  end
end

class TraitsTest < MiniTest::Unit::TestCase
  def test_call_a_trait_method
    klass = Class.new do
      uses Shapeable
    end

    foo = klass.new
    foo.sides = 4
    assert_equal 4, foo.sides
  end

  def test_detects_conflicts
    klass = Class.new do
      uses Shapeable
      uses Colorable
    end

    foo = klass.new
    assert_raises TraitConflict do
      foo.color
    end
  end

  def test_override_conflict_of_trait_method
    klass = Class.new do
      uses Colorable
      uses Shapeable

      def ==(other)
        colorable_equal = trait_send(Colorable, :==, other)
        shapeable_equal = trait_send(Shapeable, :==, other)
        colorable_equal && shapeable_equal
      end
    end

    square_one = klass.new
    square_one.sides = 4
    square_one.color = 0xFFF

    square_two = klass.new
    square_two.sides = 4
    square_two.color = 0xFFF

    square_three = klass.new
    square_three.sides = 3
    square_three.color = 0xFFF

    assert_equal square_one, square_two
    refute_equal square_one, square_three
  end

  def test_call_specific_implementation
    klass = Class.new do
      uses Shapeable
      def double_perimeter
        trait_send(Shapeable, :perimeter) * 2
      end
    end

    foo = klass.new
    foo.sides = 4
    assert_equal 80, foo.double_perimeter
  end
end