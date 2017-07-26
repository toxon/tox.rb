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
  # Friend representation in Tox client.
  #
  class Friend
    attr_reader :client, :number

    def initialize(client, number)
      self.client = client
      self.number = number
    end

    def exist!
      raise NotFoundError, "friend #{number} not found" unless exist?
      self
    end

    alias exists! exist!

  private

    def client=(value)
      raise TypeError, "expected client to be a #{Client}" unless value.is_a? Client
      @client = value
    end

    def number=(value)
      raise TypeError,     "expected number to be a #{Integer}"                  unless value.is_a? Integer
      raise ArgumentError, 'expected number to be greater than or equal to zero' unless value >= 0
      @number = value
    end

    class NotFoundError     < RuntimeError; end
    class NotConnectedError < RuntimeError; end
  end
end
