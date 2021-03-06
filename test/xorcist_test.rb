require 'test_helper'

class XorcistTest < Minitest::Test
  include Xorcist

  def test_xor
    assert_equal ZERO, xor(X, X)
    assert_equal ONE,  xor(X, INVX)
    assert_equal X,    xor(X, ZERO)
    assert_equal INVX, xor(X, ONE)
  end

  def test_xor_in_place
    a = "String"
    b = a

    frozen_strings_dependent {
      xor!(b, X)
      assert_equal(a, b)
      refute_equal("String", b)
    }
  end

  class A; end

  def test_xor_type_checking
    assert_raises(TypeError) {
      xor(A, "string")
    }

    assert_raises(TypeError) {
      xor("string", A)
    }
  end

  def test_xor_frozen
    a = "An0ther-5tring".freeze
    assert_raises(RuntimeError) { xor!(a, X) }
    b = xor!(a.dup, X)
    assert_equal b, xor(a, X)
  end

  #
  # MRI-specific tests for different string storage behaviors in MRI
  # Might as well run them in other Rubies too
  # See http://patshaughnessy.net/2012/1/4/never-create-ruby-strings-longer-than-23-characters
  # for details.
  #

  def test_embedded_string
    a = "Embedded string"
    assert a.size <= 23
    b = a.dup
    xor!(b, X)
    refute_equal(a, b)
  end

  def test_heap_string
    a = "A very long string that's stored on the heap"
    assert a.size > 24
    b = a.dup
    xor!(b, X*2)
    refute_equal(a, b)
  end
end
