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

RSpec.describe Tox::Version do
  describe '::GEM_VERSION' do
    specify do
      expect(described_class::GEM_VERSION).to match(/\A(\d+)\.(\d+)\.(\d+)\z/)
    end
  end

  describe '::TOX_VERSION' do
    specify do
      expect(described_class::TOX_VERSION).to eq [
        described_class::MAJOR,
        described_class::MINOR,
        described_class::PATCH,
      ].join '.'
    end
  end

  describe '::MAJOR' do
    specify do
      expect(described_class::MAJOR).to be_kind_of Integer
    end
  end

  describe '::MINOR' do
    specify do
      expect(described_class::MINOR).to be_kind_of Integer
    end
  end

  describe '::PATCH' do
    specify do
      expect(described_class::PATCH).to be_kind_of Integer
    end
  end

  describe '.tox_version' do
    specify do
      expect(described_class.tox_version).to eq [
        described_class.major,
        described_class.minor,
        described_class.patch,
      ].join '.'
    end
  end

  describe '.major' do
    specify do
      expect(described_class.major).to be_kind_of Integer
    end
  end

  describe '.minor' do
    specify do
      expect(described_class.minor).to be_kind_of Integer
    end
  end

  describe '.patch' do
    specify do
      expect(described_class.patch).to be_kind_of Integer
    end
  end
end
