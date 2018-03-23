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
  # Gem, library API and ABI version strings and component numbers.
  #
  module Version
    # Gem version.
    GEM_VERSION = '0.0.2'

    def self.const_missing(name)
      return "#{API_MAJOR}.#{API_MINOR}.#{API_PATCH}" if name == :API_VERSION
      super
    end

    def self.abi_version
      "#{abi_major}.#{abi_minor}.#{abi_patch}"
    end
  end
end
