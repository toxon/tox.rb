# frozen_string_literal: true

RSpec.describe Tox::Node do
  subject { described_class.new data }

  let :data do
    {
      'ipv4'       => ipv4,
      'ipv6'       => ipv6,
      'port'       => port,
      'tcp_ports'  => tcp_ports,
      'public_key' => public_key.to_s,
      'maintainer' => maintainer,
      'location'   => location,
      'status_udp' => status_udp,
      'status_tcp' => status_tcp,
      'version'    => version,
      'motd'       => motd,
      'last_ping'  => last_ping.to_i,
    }
  end

  let(:ipv4)       { 'biribiri.org' }
  let(:ipv6)       { '-' }
  let(:port)       { 33_445 }
  let(:tcp_ports)  { [33_445, 3_389] }
  let(:maintainer) { 'nurupo' }
  let(:location)   { 'US' }
  let(:status_udp) { true }
  let(:status_tcp) { true }
  let(:version)    { '2016010100' }
  let(:motd)       { Faker::Lorem.sentences.join ' ' }
  let(:last_ping)  { Time.at 1_500_570_970 }

  let :public_key do
    Tox::PublicKey.new(
      'F404ABAA1C99A9D37D61AB54898F56793E1DEF8BD46B1038B9D822E8460FAB67',
    )
  end

  describe '#ipv4' do
    it 'returns given value' do
      expect(subject.ipv4).to eq ipv4
    end
  end

  describe '#port' do
    it 'returns given value' do
      expect(subject.port).to eq port
    end
  end

  describe '#public_key' do
    it 'returns given value' do
      expect(subject.public_key).to eq public_key
    end
  end

  describe '#status_udp' do
    it 'returns given value' do
      expect(subject.status_udp).to eq status_udp
    end
  end

  describe '#resolv_ipv4' do
    it 'returns resolved IPv4 address' do
      expect(subject.resolv_ipv4).to eq Resolv.getaddress ipv4
    end
  end
end
