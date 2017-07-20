# frozen_string_literal: true

# tox.rb - Ruby interface for libtoxcore
# Copyright (C) 2015-2017  Braiden Vasco
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
  # Tox node credentials.
  #
  class Node
    # Range of valid port numbers.
    PORT_RANGE = 0..65_535

    attr_reader :public_key, :port, :ipv4

    def initialize(public_key, port, ipv4_host)
      self.public_key = public_key
      self.port       = port
      self.ipv4       = Resolv.getaddress ipv4_host
    end

  private

    def public_key=(value)
      @public_key = PublicKey.new value
    end

    def port=(value)
      raise TypeError,     "expected value to be an #{Integer}"       unless value.is_a? Integer
      raise ArgumentError, 'expected value to be between 0 and 65535' unless PORT_RANGE.cover? value
      @port = value
    end

    def ipv4=(value)
      raise TypeError, "expected value to be a #{String}" unless value.is_a? String
      @ipv4 = value.frozen? ? value : value.dup.freeze
    end
  end
end
