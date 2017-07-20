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

RSpec.describe Tox::Options do
  subject { described_class.new }

  describe '#savedata' do
    it 'returns nil by default' do
      expect(subject.savedata).to eq nil
    end

    context 'when it was set to byte string' do
      let(:savedata) { SecureRandom.random_bytes(100).freeze }

      before do
        subject.savedata = savedata
      end

      it 'returns given string' do
        expect(subject.savedata).to eq savedata
      end
    end

    context 'when it was set to something and then to nil' do
      before do
        subject.savedata = SecureRandom.random_bytes(100).freeze
        subject.savedata = nil
      end

      it 'returns nil' do
        expect(subject.savedata).to eq nil
      end
    end
  end

  describe '#savedata=' do
    context 'when called by #public_send with nil' do
      it 'returns nil' do
        expect(subject.public_send(:savedata=, nil)).to eq nil
      end
    end

    context 'when called by #public_send with string' do
      let(:savedata) { SecureRandom.random_bytes(100).freeze }

      it 'returns given string' do
        expect(subject.public_send(:savedata=, savedata)).to eq savedata
      end
    end
  end
end
