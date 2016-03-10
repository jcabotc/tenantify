require 'tenantify/middleware/strategies/host'

RSpec.describe Tenantify::Middleware::Strategies::Host do

  let :config do
    {
      'tenant_1' => ['www.host_a.com', 'www.host_b.com'],
      'tenant_2' => ['www.host_c.com', 'www.host_d.com']
    }
  end

  subject { described_class.new config }

  describe '#tenant_for' do
    context 'with a valid host' do
      let(:env) { {"SERVER_NAME" => 'www.host_c.com'} }

      it 'chooses the proper tenant' do
        expect(subject.tenant_for(env)).to eq 'tenant_2'
      end
    end

    context 'with an invalid host' do
      let(:env) { {"SERVER_NAME" => 'www.another_host.com'} }

      it 'returns nil' do
        expect(subject.tenant_for(env)).to be_nil
      end
    end
  end

end
