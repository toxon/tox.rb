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

RSpec.describe Tox::PublicKey do
  subject { described_class.new hex }

  let(:hex) { SecureRandom.hex(32).upcase.freeze }

  let(:bin) { [hex].pack('H*').freeze }

  it { is_expected.to be_frozen }

  describe '#initialize' do
    context 'when binary value provided' do
      subject { described_class.new bin }

      it { is_expected.to be_frozen }

      it 'represents it as is' do
        expect(subject).to eq bin
      end
    end
  end

  it 'equals binary value' do
    expect(subject).to eq bin
  end

  describe '#to_s' do
    it 'returns hexadecimal value' do
      expect(subject.to_hex).to eq hex
    end
  end

  describe '#inspect' do
    it 'returns inspected value' do
      expect(subject.inspect).to \
        eq "#<#{described_class}: \"#{subject.to_hex}\">"
    end
  end
end
