# frozen_string_literal: true

RSpec.describe Tox::Client do
  subject { described_class.new }

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

  describe '#running?' do
    it 'returns false by default' do
      expect(subject.running?).to eq false
    end

    context 'when client is running' do
      let :thread do
        Thread.start do
          subject.run
        end
      end

      before do
        thread
        sleep 0.01
      end

      after do
        subject.stop
        thread.join
      end

      specify do
        expect(subject.running?).to eq true
      end
    end

    context 'when client has been stopped' do
      let :thread do
        Thread.start do
          subject.run
        end
      end

      before do
        thread
        sleep 0.01
        subject.stop
      end

      after do
        thread.join
      end

      specify do
        expect(subject.running?).to eq false
      end
    end
  end

  describe '#run' do
    context 'when client is already running' do
      let :thread do
        Thread.start do
          subject.run
        end
      end

      before do
        thread
        sleep 0.01
      end

      after do
        subject.stop
        thread.join
      end

      specify do
        expect do
          Timeout.timeout 1 do
            subject.run
          end
        end.to raise_error(
          described_class::AlreadyRunningError,
          "already running in #{thread}",
        )
      end
    end
  end

  describe '#stop' do
    context 'when client is not running' do
      specify do
        expect(subject.stop).to eq false
      end
    end

    context 'when client is running' do
      let :thread do
        Thread.start do
          subject.run
        end
      end

      before do
        thread
        sleep 0.01
      end

      after do
        subject.stop
        thread.join
      end

      specify do
        expect(subject.stop).to eq true
      end

      it 'stops client' do
        subject.stop

        expect do
          Timeout.timeout 1 do
            thread.join
          end
        end.not_to raise_error
      end
    end
  end

  describe '#status' do
    it 'returns NONE by default' do
      expect(subject.status).to eq Tox::UserStatus::NONE
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
end
