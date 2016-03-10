require 'tenantify/middleware/strategies/header'

RSpec.describe Tenantify::Middleware::Strategies::Header do

  let(:config) { {:name => 'X-Tenant'} }

  subject { described_class.new config }

  describe '#tenant_for' do
    context 'when the header exists' do
      let(:env) { {'X-Tenant' => 'the_tenant'} }

      it 'returns the header content' do
        expect(subject.tenant_for(env)).to eq 'the_tenant'
      end
    end

    context 'when there is no header' do
      let(:env) { {'Another-Header' => 'a_value'} }

      it 'returns nil' do
        expect(subject.tenant_for(env)).to be_nil
      end
    end
  end

end
