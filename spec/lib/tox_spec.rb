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

RSpec.describe Tox do
  describe '.hash' do
    it 'returns proper hash for empty string' do
      expect(described_class.hash('')).to eq OpenSSL::Digest::SHA256.digest ''
    end

    specify do
      expect(described_class.hash('abc')).to eq OpenSSL::Digest::SHA256.digest 'abc'
    end

    specify do
      expect(described_class.hash('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')).to \
        eq OpenSSL::Digest::SHA256.digest 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq'
    end

    specify do
      expect(described_class.hash('aaaaaaaaaa')).to eq OpenSSL::Digest::SHA256.digest 'aaaaaaaaaa'
    end

    context 'for random small data' do
      let(:data) { SecureRandom.random_bytes rand 10...100 }

      specify do
        expect(described_class.hash(data)).to eq OpenSSL::Digest::SHA256.digest data
      end
    end

    context 'for random large data' do
      let(:data) { SecureRandom.random_bytes rand 100_000...1_000_000 }

      specify do
        expect(described_class.hash(data)).to eq OpenSSL::Digest::SHA256.digest data
      end
    end
  end
end
