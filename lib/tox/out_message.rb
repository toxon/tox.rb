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
  # Abstract module for outgoing message representation in Tox client.
  #
  module OutMessage
    def initialize(*)
      raise NotImplementedError, "#{self.class}#initialize"
    end

    def client
      raise NotImplementedError, "#{self.class}#client"
    end

    class SendQueueAllocError < NoMemoryError; end
    class TooLongError        < RuntimeError;  end
    class EmptyError          < RuntimeError;  end
  end
end
