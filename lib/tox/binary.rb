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
  class Binary < String
    def self.bytesize
      raise NotImplementedError, "#{self}.bytesize"
    end

    def self.hex_re
      /\A[\da-fA-F]{#{2 * bytesize}}\z/
    end

    def initialize(value) # rubocop:disable Metrics/MethodLength
      unless value.is_a? String
        raise TypeError, "expected value to be a #{String}"
      end

      if value.bytesize == self.class.bytesize
        super value
      else
        unless value =~ self.class.hex_re
          raise ArgumentError, 'expected value to be a hex string'
        end
        super [value].pack('H*')
      end

      to_hex
      freeze
    end

    def to_hex
      @to_hex ||= unpack('H*').first.upcase.freeze
    end

    def inspect
      "#<#{self.class}: \"#{to_hex}\">"
    end
  end
end
