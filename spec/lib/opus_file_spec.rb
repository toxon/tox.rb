# frozen_string_literal: true

RSpec.describe OpusFile do
  subject { described_class.new filename }

  let :filename do
    File.expand_path('../../multimedia/test.opus', __dir__).freeze
  end

  describe '#initialize' do
    context 'when filename is not a string' do
      let(:filename) { 123 }

      specify do
        expect { subject }.to raise_error TypeError
      end
    end

    context 'when filename contains null bytes' do
      let(:filename) { "foo\x00bar" }

      specify do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context 'when file is not a valid Ogg/Opus file' do
      let(:filename) { __FILE__ }

      specify do
        expect { subject }.to raise_error RuntimeError
      end
    end
  end

  describe '#seekable?' do
    specify do
      expect(subject.seekable?).to eq true
    end
  end

  describe '#link_count' do
    specify do
      expect(subject.link_count).to eq 1
    end
  end

  describe '#current_link' do
    specify do
      expect(subject.current_link).to eq 0
    end
  end

  describe '#serialno' do
    specify do
      expect(subject.serialno(-1)).to eq 905_075_526
    end
  end

  describe '#channel_count' do
    specify do
      expect(subject.channel_count(-1)).to eq 2
    end
  end

  describe '#raw_total' do
    specify do
      expect(subject.raw_total(-1)).to eq 2_629_170
    end
  end

  describe '#pcm_total' do
    specify do
      expect(subject.pcm_total(-1)).to eq 10_949_120
    end
  end

  describe '#bitrate' do
    specify do
      expect(subject.bitrate(-1)).to eq 92_208
    end
  end

  describe '#raw_tell' do
    specify do
      expect(subject.raw_tell).to be_kind_of Integer
    end
  end

  describe '#pcm_tell' do
    specify do
      expect(subject.pcm_tell).to eq 0
    end

    specify do
      samples_per_channel = rand 0..10
      samples = samples_per_channel * 2

      expect { subject.read samples }.to \
        change(subject, :pcm_tell).by(samples_per_channel)
    end

    specify do
      subject.read 8
      expect(subject.pcm_tell).to eq 4
      subject.read 0
      expect(subject.pcm_tell).to eq 4
      subject.read 3
      expect(subject.pcm_tell).to eq 5
      subject.read 1
      expect(subject.pcm_tell).to eq 5
      subject.read 5
      expect(subject.pcm_tell).to eq 7
      subject.read 2
      expect(subject.pcm_tell).to eq 8
    end
  end

  describe '#read' do
    let :data do
      (
        +"\x00\x00\x00\x00\x00\x00\x00\x00" \
          "\x00\x00\x01\x00\x00\x00\xFE\xFF" \
          "\xFF\xFF\x03\x00\x02\x00\xFD\xFF" \
          "\xFD\xFF\x03\x00\x04\x00\xFD\xFF"
      ).force_encoding('BINARY')
    end

    specify do
      expect { subject.read(-1) }.to raise_error ArgumentError
    end

    specify do
      expect(subject.read(0)).to eq ''
    end

    specify do
      expect(subject.read(1)).to eq ''
    end

    specify do
      expect(subject.read(2)).to eq data[0...4]
    end

    specify do
      expect(subject.read(16)).to eq data[0...32]
    end

    specify do
      expect(subject.read(8)).to eq data[0...16]
      expect(subject.read(8)).to eq data[16...32]
    end

    specify do
      expect(subject.read(8)).to eq data[0...16]
      expect(subject.read(0)).to eq ''
      expect(subject.read(3)).to eq data[16...20]
      expect(subject.read(1)).to eq ''
      expect(subject.read(5)).to eq data[20...28]
      expect(subject.read(2)).to eq data[28...32]
    end
  end
end
