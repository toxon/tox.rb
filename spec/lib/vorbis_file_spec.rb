# frozen_string_literal: true

RSpec.describe VorbisFile do
  subject { described_class.new filename }

  let :filename do
    File.expand_path('../../multimedia/test_vorbis.ogg', __dir__).freeze
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

    context 'when file is not a valid Ogg/Vorbis file' do
      let(:filename) { __FILE__ }

      specify do
        expect { subject }.to raise_error RuntimeError
      end
    end
  end
end
