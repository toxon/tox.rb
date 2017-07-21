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

RSpec.describe Tox::Status do
  subject { described_class.new }

  it { is_expected.not_to respond_to :data }

  describe '#url' do
    specify do
      expect(subject.url).to eq described_class::OFFICIAL_URL
    end
  end

  describe '#inspect' do
    specify do
      expect(subject.inspect).to eq \
        "#<#{described_class} last_refresh: #{subject.last_refresh}, last_scan: #{subject.last_scan}>"
    end

    specify do
      expect(subject.inspect).to be_frozen
    end
  end

  describe '#last_refresh' do
    specify do
      expect(subject.last_refresh).to be_a Time
    end

    specify do
      expect(subject.last_refresh).to be_frozen
    end
  end

  describe '#last_scan' do
    specify do
      expect(subject.last_scan).to be_a Time
    end

    specify do
      expect(subject.last_scan).to be_frozen
    end
  end

  describe '#udp_nodes' do
    specify do
      expect(subject.udp_nodes).to be_a Array
    end

    specify do
      subject.udp_nodes.each do |node|
        expect(node).to be_a Tox::Node
      end
    end
  end
end
