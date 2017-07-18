# frozen_string_literal: true

require 'tox'

RSpec.describe Tox::Status do
  subject { described_class.new }

  describe '#last_scan' do
    specify do
      expect(subject.last_scan).to be_a Time
    end
  end

  describe '#last_refresh' do
    specify do
      expect(subject.last_refresh).to be_a Time
    end
  end
end
