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

RSpec.describe Tox::UserStatus do
  describe '::NONE' do
    specify do
      expect(described_class::NONE).to eq :none
    end
  end

  describe '::AWAY' do
    specify do
      expect(described_class::AWAY).to eq :away
    end
  end

  describe '::BUSY' do
    specify do
      expect(described_class::BUSY).to eq :busy
    end
  end
end
