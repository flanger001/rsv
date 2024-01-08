# frozen_string_literal: true

require "test_helper"

class TestRsv < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rsv::VERSION
  end

  def test_encode_strings
    expected = [72, 101, 108, 108, 111, 255, 240, 159, 140, 141, 255, 253]
    rows = [
      ["Hello", "🌍"]
    ]
    actual = Rsv.encode(rows)
    assert_equal(expected, actual)
  end

  def test_encode_empty_rows_nil
    expected = [72, 101, 108, 108, 111, 255, 240, 159, 140, 141, 255, 253, 253, 254, 255, 255, 253]
    rows = [
      ["Hello", "🌍"],
      [],
      [nil, ""]
    ]
    actual = Rsv.encode(rows)
    assert_equal(expected, actual)
  end

  def test_encode_numbers
    expected = [72, 101, 108, 108, 111, 255, 240, 159, 140, 141, 255, 253, 51, 255, 253, 253, 254, 255, 255, 253]
    rows = [
      ["Hello", "🌍"],
      [3],
      [],
      [nil, ""]
    ]
    actual = Rsv.encode(rows)
    assert_equal(expected, actual)
  end

  def test_encode_json
    expected = [123, 125, 255, 253]
    rows = [
      [{}]
    ]
    actual = Rsv.encode(rows)
    assert_equal(expected, actual)
  end

  def test_decode_strings
    data = [72, 101, 108, 108, 111, 255, 240, 159, 140, 141, 255, 253]
    expected = [["Hello", "🌍"]]
    actual = Rsv.decode(data)
    assert_equal(expected, actual)
  end

  def test_decode_empty_rows_nil
    data = [72, 101, 108, 108, 111, 255, 240, 159, 140, 141, 255, 253, 253, 254, 255, 255, 253]
    expected = [["Hello", "🌍"], [], [nil, ""]]
    actual = Rsv.decode(data)
    assert_equal(expected, actual)
  end

  def test_decode_numbers
    data = [72, 101, 108, 108, 111, 255, 240, 159, 140, 141, 255, 253, 51, 255, 253, 253, 254, 255, 255, 253]
    expected = [["Hello", "🌍"], ["3"], [], [nil, ""]]
    actual = Rsv.decode(data)
    assert_equal(expected, actual)
  end

  def test_decode_json
    data = [123, 125, 255, 253]
    expected = [["{}"]]
    actual = Rsv.decode(data)
    assert_equal(expected, actual)
  end
end
