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
  # Represents the possible statuses a client can have.
  #
  module UserStatus
    # User is online and available.
    NONE = :none

    # User is away. Clients can set this e.g. after a user defined
    # inactivity time.
    AWAY = :away

    # User is busy. Signals to other clients that this client does not
    # currently wish to communicate.
    BUSY = :busy
  end
end
