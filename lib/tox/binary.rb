# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2018  Braiden Vasco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module Tox
  ##
  # Binary primitive representation.
  #
  class Binary
    def self.bytesize
      raise NotImplementedError, "#{self}.bytesize"
    end

    def self.hex_re
      /\A[\da-fA-F]{#{2 * bytesize}}\z/
    end

    attr_reader :value

    def initialize(value)
      unless value.is_a? String
        raise TypeError, "expected value to be a #{String}"
      end

      if value.bytesize == self.class.bytesize
        @value = value.frozen? ? value : value.dup.freeze
      elsif value =~ self.class.hex_re
        @value = [value].pack('H*').freeze
      else
        raise ArgumentError, 'expected value to be a hex or binary string'
      end
    end

    def to_s
      @to_s ||= value.unpack('H*').first.upcase.freeze
    end

    def inspect
      "#<#{self.class}: \"#{self}\">"
    end

    def ==(other)
      value == other.value
    end
  end
end
