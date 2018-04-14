# frozen_string_literal: true

require 'support/fake_bootstrap_network/instance'

RSpec.describe Support::FakeBootstrapNetwork::Instance do
  subject { described_class.new port: port }

  let(:port) { rand 1024..65_535 }

  describe '#public_key' do
    specify do
      expect(subject.public_key).to be_kind_of Tox::PublicKey
    end
  end
end
