# frozen_string_literal: true

require 'tox'

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

  describe '#nodes' do
    specify do
      expect(subject.nodes).to be_a Array
    end

    specify do
      subject.nodes.each do |node|
        expect(node).to be_a Tox::Node
      end
    end
  end
end
