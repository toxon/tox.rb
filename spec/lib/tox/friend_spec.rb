# frozen_string_literal: true

RSpec.describe Tox::Friend do
  subject { described_class.new client, friend_number }

  let(:client) { Tox::Client.new }

  let(:friend_number) { rand 0..10 }

  describe '#initialize' do
    context 'when friend number has invalid type' do
      let(:friend_number) { :foobar }

      specify do
        expect { subject }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{friend_number.class}",
        )
      end
    end

    context 'when friend number is less than zero' do
      let(:friend_number) { -1 }

      specify do
        expect { subject }.to raise_error(
          RuntimeError,
          'Expected friend number to be greater than or equal to zero',
        )
      end
    end
  end

  describe '#client' do
    specify do
      expect(subject.client).to be_instance_of Tox::Client
    end

    specify do
      expect(subject.client).to equal client
    end
  end

  describe '#friend_number' do
    specify do
      expect(subject.number).to be_a Integer
    end

    specify do
      expect(subject.number).to eq friend_number
    end
  end

  describe '#==' do
    let(:same_friend) { described_class.new client, friend_number }
    let(:with_other_client) { described_class.new other_client, friend_number }
    let(:with_other_number) { described_class.new client, other_friend_number }

    let(:other_client) { Tox::Client.new }
    let(:other_friend_number) { rand 200..300 }

    it 'returns true when compared to itself' do
      expect(subject).to eq subject
    end

    it 'returns true when values are equal' do
      expect(subject).to eq same_friend
    end

    it 'returns false when client differs' do
      expect(subject).not_to eq with_other_client
    end

    it 'returns false when number differs' do
      expect(subject).not_to eq with_other_number
    end

    it 'returns false when compared with subclass instance' do
      expect(subject).not_to \
        eq Class.new(described_class).new client, friend_number
    end
  end
end
