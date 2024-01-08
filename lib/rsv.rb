# frozen_string_literal: true

require_relative "rsv/version"

module Rsv
  class Error < StandardError; end

  VALUE_DELIMITER = 0xFF # 255
  NULL            = 0xFE # 254
  ROW_DELIMITER   = 0xFD # 253

  class << self
    # rows must be Array<Array<String | nil>>
    def encode(rows)
      rows.flat_map { |row| encode_row(row) }
    end

    def decode(binary)
      rows = []
      current_row = []
      current_value = []
      iterator = binary.each
      begin
        while (byte = iterator.next)
          case byte
          when VALUE_DELIMITER
            v = current_value.pack("C*", buffer: String.new(encoding: "UTF-8"))
            current_row.push(v)
            current_value = []
          when ROW_DELIMITER
            rows.push(current_row)
            current_row = []
          when NULL
            current_row.push(nil)
            iterator.next
            current_value = []
          else
            current_value.push(byte)
          end
        end
      rescue StopIteration
        nil
      end
      rows
    end

    def write_file(filename, rows)
      File.binwrite(filename, encode(rows).pack("C*"))
    end

    def read_file(filename)
      decode(File.binread(filename).unpack("C*"))
    end

    private

    def encode_row(row)
      raise Error unless row.is_a?(Array)
      return [ROW_DELIMITER] if row.empty?
      row.flat_map { |r| encode_value(r) }.push(ROW_DELIMITER)
    end

    def encode_value(value)
      return [NULL, VALUE_DELIMITER] if value.nil?
      value = value.to_s
      return [VALUE_DELIMITER] if value.empty?
      value.unpack("C*").push(VALUE_DELIMITER)
    end
  end
end
