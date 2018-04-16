# frozen_string_literal: true

RSpec.describe Tox::InFriendFile do
  subject { described_class.new friend, file_number }

  let(:friend) { Tox::Friend.new client, friend_number }

  let(:file_number) { rand 0..10 }

  let(:client) { Tox::Client.new }

  let(:friend_number) { rand 0..10 }

  describe '#initialize' do
    context 'when friend has invalid type' do
      let(:friend) { :foobar }

      specify do
        expect { subject }.to raise_error(
          TypeError,
          "Expected #{Tox::Friend}, got #{friend.class}",
        )
      end
    end

    context 'when file number has invalid type' do
      let(:file_number) { :foobar }

      specify do
        expect { subject }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{file_number.class}",
        )
      end
    end

    context 'when file number is less than zero' do
      let(:file_number) { -1 }

      specify do
        expect { subject }.to raise_error(
          RuntimeError,
          'Expected file number to be greater than or equal to zero',
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

  describe '#friend' do
    specify do
      expect(subject.friend).to be_instance_of Tox::Friend
    end

    specify do
      expect(subject.friend).to eq friend
    end
  end

  describe '#number' do
    specify do
      expect(subject.number).to be_kind_of Integer
    end

    specify do
      expect(subject.number).to eq file_number
    end
  end

  describe '#==' do
    let(:same) { described_class.new friend, file_number }
    let(:with_other_friend) { described_class.new other_friend, file_number }
    let(:with_other_file_num) { described_class.new friend, other_file_number }

    let(:other_friend) { Tox::Friend.new client, other_friend_number }
    let(:other_friend_number) { rand 200..300 }
    let(:other_file_number) { rand 200..300 }

    it 'returns true when compared to itself' do
      expect(subject).to eq subject
    end

    it 'returns true when values are equal' do
      expect(subject).to eq same
    end

    it 'returns false when friend differs' do
      expect(subject).not_to eq with_other_friend
    end

    it 'returns false when file number differs' do
      expect(subject).not_to eq with_other_file_num
    end

    it 'returns false when compared with subclass instance' do
      expect(subject).not_to \
        eq Class.new(described_class).new friend, file_number
    end
  end
end
