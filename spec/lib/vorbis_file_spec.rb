# frozen_string_literal: true

RSpec.describe VorbisFile do
  subject { described_class.new filename }

  let :filename do
    File.expand_path('../../multimedia/vorbis.ogg', __dir__).freeze
  end

  let(:vendor) { 'Xiph.Org libVorbis I 20120203 (Omnipresent)' }

  let :parse_comments do
    {
      'ALBUM'  => 'Example Files',
      'TITLE'  => 'OGG Test File',
      'ARTIST' => 'Online-Convert.com',
    }
  end

  let(:comments) { parse_comments.map { |s| s.join '=' } }

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

    context 'when file is not a valid Ogg/Vorbis file' do
      let(:filename) { __FILE__ }

      specify do
        expect { subject }.to raise_error RuntimeError
      end
    end
  end

  describe '#vendor' do
    specify do
      expect(subject.vendor(-1)).to eq vendor
    end

    specify do
      expect(subject.vendor(0)).to eq vendor
    end
  end

  describe '#comments' do
    specify do
      expect(subject.comments(-1)).to eq comments
    end

    specify do
      expect(subject.comments(0)).to eq comments
    end
  end

  describe '#parse_comments' do
    specify do
      expect(subject.parse_comments(-1)).to eq parse_comments
    end

    specify do
      expect(subject.parse_comments(0)).to eq parse_comments
    end
  end

  describe '#read' do
    let :data do
      (
        +"\xF0\xFF\x1E\x00\xEE\xFF\x10\x00" \
          "\b\x00\x1D\x00\x04\x00\x1A\x00" \
          "\xF1\xFF\x15\x00\xEC\xFF'\x00" \
          "\xF6\xFF#\x00\x05\x00\x12\x00"
      ).force_encoding('BINARY')
    end

    specify do
      expect { subject.read(-1) }.to raise_error ArgumentError
    end

    specify do
      expect(subject.read(32)).to eq data[0...32]
    end

    specify do
      expect(subject.read(16)).to eq data[0...16]
      expect(subject.read(16)).to eq data[16...32]
    end

    specify do
      expect(subject.read(16)).to eq data[0...16]
      expect(subject.read(6)).to  eq data[16...20]
      expect(subject.read(10)).to eq data[20...28]
      expect(subject.read(4)).to  eq data[28...32]
    end
  end
end
