# frozen_string_literal: true

RSpec.describe Tox::VideoFrame do
  subject { described_class.new }

  before do
    subject.width  = width  if width
    subject.height = height if height

    subject.y_plane = y_plane if y_plane
    subject.u_plane = u_plane if u_plane
    subject.v_plane = v_plane if v_plane
  end

  let(:width)  { nil }
  let(:height) { nil }

  let(:y_plane) { nil }
  let(:u_plane) { nil }
  let(:v_plane) { nil }

  describe '#initialize' do
    specify do
      expect { subject }.not_to raise_error
    end
  end

  describe '#width' do
    specify do
      expect(subject.width).to eq 0
    end

    context 'when it was set' do
      let(:width) { rand 0...(2**16 - 1) }

      specify do
        expect(subject.width).to eq width
      end
    end
  end

  describe '#width=' do
    context 'when given value is not a Numeric' do
      specify do
        expect { subject.width = '12345' }.to raise_error TypeError
      end
    end
  end

  describe '#height' do
    specify do
      expect(subject.height).to eq 0
    end

    context 'when it was set' do
      let(:height) { rand 0...(2**16 - 1) }

      specify do
        expect(subject.height).to eq height
      end
    end
  end

  describe '#height=' do
    context 'when given value is not a Numeric' do
      specify do
        expect { subject.height = '12345' }.to raise_error TypeError
      end
    end
  end

  describe '#y_plane' do
    specify do
      expect(subject.y_plane).to eq ''
    end

    context 'when it was set' do
      let(:y_plane) { SecureRandom.random_bytes rand 0...10 }

      specify do
        expect(subject.y_plane).to eq y_plane
      end
    end
  end

  describe '#y_plane=' do
    context 'when given value is not a String' do
      specify do
        expect { subject.y_plane = :foobar }.to raise_error TypeError
      end
    end
  end

  describe '#u_plane' do
    specify do
      expect(subject.u_plane).to eq ''
    end

    context 'when it was set' do
      let(:u_plane) { SecureRandom.random_bytes rand 0...10 }

      specify do
        expect(subject.u_plane).to eq u_plane
      end
    end
  end

  describe '#u_plane=' do
    context 'when given value is not a String' do
      specify do
        expect { subject.u_plane = :foobar }.to raise_error TypeError
      end
    end
  end

  describe '#v_plane' do
    specify do
      expect(subject.v_plane).to eq ''
    end

    context 'when it was set' do
      let(:v_plane) { SecureRandom.random_bytes rand 0...10 }

      specify do
        expect(subject.v_plane).to eq v_plane
      end
    end
  end

  describe '#v_plane=' do
    context 'when given value is not a String' do
      specify do
        expect { subject.v_plane = :foobar }.to raise_error TypeError
      end
    end
  end

  describe '#valid?' do
    specify do
      expect(subject.valid?).to eq true
    end

    context 'when values was set' do
      let(:width)  { rand 640..1024 }
      let(:height) { rand 480..768  }

      let(:y_plane) { SecureRandom.random_bytes width * height }

      let :u_plane do
        SecureRandom.random_bytes((width / 2) * (height / 2))
      end

      let :v_plane do
        SecureRandom.random_bytes((width / 2) * (height / 2))
      end

      specify do
        expect(subject.valid?).to eq true
      end

      context 'when Y plane size is invalid' do
        let :y_plane do
          SecureRandom.random_bytes width * height + [1, -1, 2, -2].sample
        end

        specify do
          expect(subject.valid?).to eq false
        end
      end

      context 'when U plane size is invalid' do
        let :u_plane do
          SecureRandom.random_bytes(
            (width / 2) * (height / 2) + [1, -1, 2, -2].sample,
          )
        end

        specify do
          expect(subject.valid?).to eq false
        end
      end

      context 'when V plane size is invalid' do
        let :v_plane do
          SecureRandom.random_bytes(
            (width / 2) * (height / 2) + [1, -1, 2, -2].sample,
          )
        end

        specify do
          expect(subject.valid?).to eq false
        end
      end
    end
  end
end
