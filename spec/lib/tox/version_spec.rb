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

  describe '::API_VERSION' do
    specify do
      expect(described_class::API_VERSION).to eq [
        described_class::API_MAJOR,
        described_class::API_MINOR,
        described_class::API_PATCH,
      ].join '.'
    end
  end

  describe '::API_MAJOR' do
    specify do
      expect(described_class::API_MAJOR).to be_kind_of Integer
    end
  end

  describe '::API_MINOR' do
    specify do
      expect(described_class::API_MINOR).to be_kind_of Integer
    end
  end

  describe '::API_PATCH' do
    specify do
      expect(described_class::API_PATCH).to be_kind_of Integer
    end
  end

  describe '.abi_version' do
    specify do
      expect(described_class.abi_version).to eq [
        described_class.abi_major,
        described_class.abi_minor,
        described_class.abi_patch,
      ].join '.'
    end
  end

  describe '.abi_major' do
    specify do
      expect(described_class.abi_major).to be_kind_of Integer
    end
  end

  describe '.abi_minor' do
    specify do
      expect(described_class.abi_minor).to be_kind_of Integer
    end
  end

  describe '.abi_patch' do
    specify do
      expect(described_class.abi_patch).to be_kind_of Integer
    end
  end
end
