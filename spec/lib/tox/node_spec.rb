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

require 'tox'

RSpec.describe Tox::Node do
  subject { described_class.new public_key, port, ipv4 }

  let(:public_key) { '6FC41E2BD381D37E9748FC0E0328CE086AF9598BECC8FEB7DDF2E440475F300E' }
  let(:port) { 33_445 }
  let(:ipv4) { '51.15.37.145' }

  describe '#public_key' do
    it 'returns given value' do
      expect(subject.public_key).to eq Tox::PublicKey.new public_key
    end
  end

  describe '#port' do
    it 'returns given value' do
      expect(subject.port).to eq port
    end
  end

  describe '#ipv4' do
    it 'returns given value' do
      expect(subject.ipv4).to eq ipv4
    end
  end
end
