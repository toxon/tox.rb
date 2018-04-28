# frozen_string_literal: true

RSpec.describe Tox::VideoFrame do
  subject { described_class.new }

  describe '#initialize' do
    specify do
      expect { subject }.not_to raise_error
    end
  end
end
