# frozen_string_literal: true

RSpec.describe VorbisFile do
  subject { described_class.new filename }

  let :filename do
    File.expand_path('../../multimedia/test_vorbis.ogg', __dir__).freeze
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
end
