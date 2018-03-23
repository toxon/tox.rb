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

RSpec.describe Tox::Client do
  subject { described_class.new }

  describe '#initialize' do
    context 'when options is nil' do
      specify do
        expect { described_class.new nil }.to \
          raise_error TypeError, "expected options to be a #{Tox::Options}"
      end
    end

    context 'when options have invalid type' do
      specify do
        expect { described_class.new 123 }.to \
          raise_error TypeError, "expected options to be a #{Tox::Options}"
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

  describe '#public_key' do
    it 'returns public key by default' do
      expect(subject.public_key).to be_a Tox::PublicKey
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
    end
  end

  describe '#address' do
    it 'returns string by default' do
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
end
