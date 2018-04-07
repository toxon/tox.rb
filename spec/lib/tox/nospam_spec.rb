# frozen_string_literal: true

RSpec.describe Tox::Nospam do
  subject { described_class.new hex }

  let(:hex) { SecureRandom.hex(described_class.bytesize).upcase.freeze }

  let(:bin) { [hex].pack('H*').freeze }

  describe '.bytesize' do
    specify do
      expect(described_class.bytesize).to eq 4
    end
  end

  describe '#initialize' do
    context 'when integer value provided' do
      subject { described_class.new int }

      let(:int) { rand 0...2**32 }

      specify do
        expect(subject.value).to be_instance_of String
      end

      specify do
        expect(subject.value).to be_frozen
      end

      it 'converts it' do
        expect(subject.value).to eq [int].pack('L').reverse
      end
    end

    context 'when integer zero is provided' do
      subject { described_class.new 0 }

      specify do
        expect(subject.value).to be_instance_of String
      end

      specify do
        expect(subject.value).to be_frozen
      end

      it 'converts it' do
        expect(subject.value).to eq(("\x00" * 4).force_encoding('BINARY'))
      end
    end

    context 'when max integer is provided' do
      subject { described_class.new 2**32 - 1 }

      specify do
        expect(subject.value).to be_instance_of String
      end

      specify do
        expect(subject.value).to be_frozen
      end

      it 'converts it' do
        expect(subject.value).to eq(("\xFF" * 4).force_encoding('BINARY'))
      end
    end

    context 'when known integer is provided' do
      subject { described_class.new 0x12345678 }

      specify do
        expect(subject.value).to be_instance_of String
      end

      specify do
        expect(subject.value).to be_frozen
      end

      it 'converts it' do
        expect(subject.value).to \
          eq((+"\x12\x34\x56\x78").force_encoding('BINARY'))
      end
    end

    context 'when binary value provided' do
      subject { described_class.new bin }

      it 'represents it as is' do
        expect(subject.value).to eq bin
      end
    end
  end

  describe '#to_s' do
    it 'returns hexadecimal value' do
      expect(subject.to_s).to eq hex
    end
  end

  describe '#inspect' do
    it 'returns inspected value' do
      expect(subject.inspect).to \
        eq "#<#{described_class}: \"#{subject}\">"
    end
  end

  describe '#value' do
    specify do
      expect(subject.value).to be_instance_of String
    end

    specify do
      expect(subject.value).to be_frozen
    end

    it 'equals binary value' do
      expect(subject.value).to eq bin
    end
  end

  describe '#to_i' do
    specify do
      expect(subject.to_i).to be_kind_of Integer
    end

    specify do
      expect(subject.to_i).to eq bin.reverse.unpack('L').first
    end

    context 'when all bytes are zeroes' do
      let(:hex) { '00000000' }

      specify do
        expect(subject.to_i).to eq 0
      end
    end

    context 'when all bytes are 0xFF' do
      let(:hex) { 'FFFFFFFF' }

      specify do
        expect(subject.to_i).to eq 2**32 - 1
      end
    end

    context 'for known bytes' do
      let(:hex) { '12345678' }

      specify do
        expect(subject.to_i).to eq 0x12345678
      end
    end
  end

  describe '#==' do
    it 'returns true when values are equal' do
      expect(subject).to eq described_class.new hex
    end

    it 'returns false when values are different' do
      expect(subject).not_to \
        eq described_class.new SecureRandom.hex described_class.bytesize
    end

    it 'returns false when compared with own hexadecimal value' do
      expect(subject).not_to eq hex
    end

    it 'returns false when compared with own binary value' do
      expect(subject).not_to eq bin
    end

    it 'returns false when compared with different kind of binary' do
      bytesize = described_class.bytesize

      expect(subject).not_to eq(
        Class.new(Tox::Binary) do
          @bytesize = bytesize

          class << self
            attr_reader :bytesize
          end
        end.new(hex),
      )
    end

    it 'returns false when compared with subclass instance' do
      expect(subject).not_to eq Class.new(described_class).new hex
    end
  end
end
