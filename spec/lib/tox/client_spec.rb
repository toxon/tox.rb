# frozen_string_literal: true

RSpec.describe Tox::Client do
  subject { described_class.new }

  pending '#bootstrap'
  pending '#bootstrap_official'
  pending '#add_tcp_relay'

  describe '#initialize' do
    context 'when options is nil' do
      specify do
        expect { described_class.new nil }.to \
          raise_error(
            TypeError,
            'Expected method Tox::Client#initialize_with ' \
              'argument "options" '                        \
              "to be a #{Tox::Options}",
          )
      end
    end

    context 'when options have invalid type' do
      specify do
        expect { described_class.new 123 }.to \
          raise_error(
            TypeError,
            'Expected method Tox::Client#initialize_with ' \
              'argument "options" '                        \
              "to be a #{Tox::Options}",
          )
      end
    end

    context 'when savedata format is invalid' do
      subject { described_class.new tox_options }

      let :tox_options do
        result = Tox::Options.new
        result.savedata = savedata
        result
      end

      let(:savedata) { 'foobar' }

      specify do
        expect { subject }.to raise_error described_class::BadSavedataError
      end
    end
  end

  describe '#audio_video' do
    specify do
      expect(subject.audio_video).to be_instance_of Tox::AudioVideo
    end
  end

  describe '#iteration_interval' do
    specify do
      expect(subject.iteration_interval).to be_instance_of Float
    end

    specify do
      expect(subject.iteration_interval).to be >= 0
    end
  end

  describe '#iterate' do
    specify do
      expect(subject.iterate).to eq nil
    end
  end

  describe '#savedata' do
    it 'returns string by default' do
      expect(subject.savedata).to be_a String
    end

    context 'when it was set via options' do
      subject { described_class.new tox_options }

      let :tox_options do
        result = Tox::Options.new
        result.savedata = savedata
        result
      end

      let(:savedata) { Tox::Client.new.savedata }

      it 'can be set via options' do
        expect(subject.savedata).to eq savedata
      end
    end
  end

  describe '#address' do
    specify do
      expect(subject.address).to be_a Tox::Address
    end

    context 'when savedata was set' do
      subject { described_class.new tox_options }

      let :tox_options do
        result = Tox::Options.new
        result.savedata = savedata
        result
      end

      let(:savedata) { old_tox.savedata }

      let(:old_tox) { Tox::Client.new }

      it 'can be set via options' do
        expect(subject.address).to eq old_tox.address
      end
    end

    context 'when nospam was changed' do
      before do
        subject.nospam = new_nospam
      end

      let(:new_nospam) { Tox::Nospam.new SecureRandom.hex Tox::Nospam.bytesize }

      specify do
        expect(subject.address.nospam).to eq new_nospam
      end
    end
  end

  describe '#public_key' do
    specify do
      expect(subject.public_key).to be_a Tox::PublicKey
    end

    it 'equals public key extracted from address' do
      expect(subject.public_key).to eq subject.address.public_key
    end

    context 'when savedata was set' do
      subject { described_class.new tox_options }

      let :tox_options do
        result = Tox::Options.new
        result.savedata = savedata
        result
      end

      let(:savedata) { old_tox.savedata }

      let(:old_tox) { Tox::Client.new }

      it 'can be set via options' do
        expect(subject.public_key).to eq old_tox.public_key
      end

      it 'equals public key extracted from old address' do
        expect(subject.public_key).to eq old_tox.address.public_key
      end
    end
  end

  describe '#nospam' do
    specify do
      expect(subject.nospam).to be_instance_of Tox::Nospam
    end

    it 'equals nospam extracted from address' do
      expect(subject.nospam).to eq subject.address.nospam
    end

    context 'when savedata was set' do
      subject { described_class.new tox_options }

      let :tox_options do
        result = Tox::Options.new
        result.savedata = savedata
        result
      end

      let(:savedata) { old_tox.savedata }

      let(:old_tox) { Tox::Client.new }

      it 'can be set via options' do
        expect(subject.nospam).to eq old_tox.nospam
      end

      it 'equals nospam extracted from old address' do
        expect(subject.nospam).to eq old_tox.address.nospam
      end
    end

    context 'when it was changed' do
      before do
        subject.nospam = new_nospam
      end

      let(:new_nospam) { Tox::Nospam.new SecureRandom.hex Tox::Nospam.bytesize }

      specify do
        expect(subject.nospam).to eq new_nospam
      end
    end
  end

  describe '#nospam=' do
    context 'when invalid value given' do
      specify do
        expect { subject.nospam = :foobar }.to raise_error(
          TypeError,
          'Expected method Tox::Client#nospam= ' \
            'argument "nospam" '                 \
            "to be a #{Tox::Nospam}",
        )
      end
    end
  end

  describe '#udp_port' do
    subject { described_class.new options }

    let :options do
      Tox::Options.new.tap do |options|
        options.udp_enabled = udp_enabled
        options.start_port = udp_port
        options.end_port = udp_port
      end
    end

    let(:udp_port) { random_port }

    context 'when UDP is disabled' do
      let(:udp_enabled) { false }

      specify do
        expect(subject.udp_port).to eq nil
      end
    end

    context 'when UDP is enabled' do
      let(:udp_enabled) { true }

      specify do
        expect(subject.udp_port).to be_kind_of Integer
      end

      specify do
        expect(subject.udp_port).to eq udp_port
      end
    end
  end

  describe '#tcp_port' do
    subject { described_class.new options }

    let :options do
      Tox::Options.new.tap do |options|
        options.tcp_port = tcp_port
      end
    end

    context 'when TCP is disabled' do
      let(:tcp_port) { 0 }

      specify do
        expect(subject.tcp_port).to eq nil
      end
    end

    context 'when TCP is enabled' do
      let(:tcp_port) { random_port }

      specify do
        expect(subject.tcp_port).to be_kind_of Integer
      end

      specify do
        expect(subject.tcp_port).to eq tcp_port
      end
    end
  end

  describe '#name' do
    it 'returns empty string by default' do
      expect(subject.name).to eq ''
    end

    context 'when it was set' do
      before do
        subject.name = name
      end

      let(:name) { SecureRandom.hex }

      it 'returns given value' do
        expect(subject.name).to eq name
      end
    end

    context 'when it was set to empty string' do
      before do
        subject.name = ''
      end

      it 'returns empty string' do
        expect(subject.name).to eq ''
      end
    end
  end

  describe '#name=' do
    context 'when invalid value given' do
      specify do
        expect { subject.name = :foobar }.to \
          raise_error(
            TypeError,
            "wrong argument type #{Symbol} (expected #{String})",
          )
      end
    end
  end

  describe '#status' do
    it 'returns NONE by default' do
      expect(subject.status).to eq Tox::UserStatus::NONE
    end

    context 'when it was set to NONE' do
      before do
        subject.status = Tox::UserStatus::AWAY
        subject.status = Tox::UserStatus::NONE
      end

      it 'returns given value' do
        expect(subject.status).to eq Tox::UserStatus::NONE
      end
    end

    context 'when it was set to AWAY' do
      before do
        subject.status = Tox::UserStatus::AWAY
      end

      it 'returns given value' do
        expect(subject.status).to eq Tox::UserStatus::AWAY
      end
    end

    context 'when it was set to BUSY' do
      before do
        subject.status = Tox::UserStatus::BUSY
      end

      it 'returns given value' do
        expect(subject.status).to eq Tox::UserStatus::BUSY
      end
    end
  end

  describe '#status=' do
    context 'when invalid value given' do
      specify do
        expect { subject.status = :foobar }.to \
          raise_error ArgumentError, "Invalid value from #{Tox::UserStatus}"
      end
    end
  end

  describe '#status_message' do
    it 'returns empty string by default' do
      expect(subject.status_message).to eq ''
    end

    context 'when it was set' do
      before do
        subject.status_message = status_message
      end

      let(:status_message) { SecureRandom.hex }

      it 'returns given value' do
        expect(subject.status_message).to eq status_message
      end
    end

    context 'when it was set to empty string' do
      before do
        subject.status_message = ''
      end

      it 'returns empty string' do
        expect(subject.status_message).to eq ''
      end
    end
  end

  describe '#status_message=' do
    context 'when invalid value given' do
      specify do
        expect { subject.status_message = :foobar }.to \
          raise_error(
            TypeError,
            "wrong argument type #{Symbol} (expected #{String})",
          )
      end
    end
  end

  describe '#status=' do
    context 'when invalid value given' do
      specify do
        expect { subject.status = :foobar }.to raise_error ArgumentError
      end
    end
  end

  describe '#friend_add_norequest' do
    let :new_friend_public_key do
      Tox::Client.new.public_key
    end

    specify do
      expect(subject.friend_add_norequest(new_friend_public_key)).to \
        be_instance_of Tox::Friend
    end

    specify do
      expect(subject.friend_add_norequest(new_friend_public_key).client).to \
        equal subject
    end

    context 'with own public key' do
      specify do
        expect { subject.friend_add_norequest subject.public_key }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add_norequest() failed with TOX_ERR_FRIEND_ADD_OWN_KEY',
          )
      end
    end

    context 'when already added' do
      before do
        subject.friend_add_norequest new_friend_public_key
      end

      specify do
        expect { subject.friend_add_norequest new_friend_public_key }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add_norequest() failed with ' \
              'TOX_ERR_FRIEND_ADD_ALREADY_SENT',
          )
      end
    end

    context 'when public key is invalid' do
      let :new_friend_public_key do
        Tox::PublicKey.new 'AA' * Tox::PublicKey.bytesize
      end

      specify do
        expect { subject.friend_add_norequest new_friend_public_key }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add_norequest() failed with ' \
              'TOX_ERR_FRIEND_ADD_BAD_CHECKSUM',
          )
      end
    end

    context 'when public key has invalid type' do
      let(:new_friend_public_key) { :foobar }

      specify do
        expect { subject.friend_add_norequest new_friend_public_key }.to \
          raise_error(
            TypeError,
            'Expected method Tox::Client#friend_add_norequest ' \
              'argument "public_key" '                          \
              "to be a #{Tox::PublicKey}",
          )
      end
    end
  end

  describe '#friend_add' do
    let(:new_friend_client) { Tox::Client.new }

    let(:new_friend_address) { new_friend_client.address }

    let(:message) { SecureRandom.hex }

    specify do
      expect(subject.friend_add(new_friend_address, message)).to \
        be_instance_of Tox::Friend
    end

    context 'with own address' do
      specify do
        expect { subject.friend_add subject.address, message }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add() failed with TOX_ERR_FRIEND_ADD_OWN_KEY',
          )
      end
    end

    context 'when already added' do
      before do
        subject.friend_add new_friend_address, message
      end

      specify do
        expect { subject.friend_add new_friend_address, message }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add() failed with TOX_ERR_FRIEND_ADD_ALREADY_SENT',
          )
      end
    end

    context 'when address is invalid' do
      let :new_friend_address do
        Tox::Address.new 'AA' * Tox::Address.bytesize
      end

      specify do
        expect { subject.friend_add new_friend_address, message }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add() failed with TOX_ERR_FRIEND_ADD_BAD_CHECKSUM',
          )
      end
    end

    context 'when message is empty' do
      let(:message) { '' }

      specify do
        expect { subject.friend_add new_friend_address, message }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add() failed with TOX_ERR_FRIEND_ADD_NO_MESSAGE',
          )
      end
    end

    context 'when message is too long' do
      let(:message) { 'A' * 2**14 }

      specify do
        expect { subject.friend_add new_friend_address, message }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add() failed with TOX_ERR_FRIEND_ADD_TOO_LONG',
          )
      end
    end

    context 'when already added with different nospam value' do
      before do
        subject.friend_add new_friend_address, message

        new_friend_client.nospam =
          Tox::Nospam.new SecureRandom.hex Tox::Nospam.bytesize
      end

      specify do
        expect { subject.friend_add new_friend_client.address, message }.to \
          raise_error(
            RuntimeError,
            'tox_friend_add() failed with TOX_ERR_FRIEND_ADD_SET_NEW_NOSPAM',
          )
      end
    end

    context 'when address has invalid type' do
      let(:new_friend_address) { :foobar }

      specify do
        expect { subject.friend_add new_friend_address, message }.to \
          raise_error(
            TypeError,
            'Expected method Tox::Client#friend_add ' \
              'argument "address" '                   \
              "to be a #{Tox::Address}",
          )
      end
    end

    context 'when message has invalid type' do
      let(:message) { 123 }

      specify do
        expect { subject.friend_add new_friend_address, message }.to \
          raise_error(
            TypeError,
            "wrong argument type #{message.class} (expected #{String})",
          )
      end
    end
  end

  describe '#friend' do
    let(:friend) { subject.friend friend_number }

    let(:friend_number) { rand 0..10 }

    specify do
      expect(friend).to eq Tox::Friend.new subject, friend_number
    end

    specify do
      expect(friend).to be_instance_of Tox::Friend
    end

    specify do
      expect(friend.client).to equal subject
    end

    specify do
      expect(friend.number).to eq friend_number
    end

    context 'when friend number has invalid type' do
      let(:friend_number) { :foobar }

      specify do
        expect { friend }.to raise_error(
          TypeError,
          "Expected #{Integer}, got #{friend_number.class}",
        )
      end
    end

    context 'when friend number is less than zero' do
      let(:friend_number) { -1 }

      specify do
        expect { friend }.to raise_error(
          RuntimeError,
          'Expected friend number to be greater than or equal to zero',
        )
      end
    end
  end
end
