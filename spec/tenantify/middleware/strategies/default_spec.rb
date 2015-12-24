require 'tenantify/middleware/strategies/default'

RSpec.describe Tenantify::Middleware::Strategies::Default do

  let(:config) { {:tenant => 'the_tenant'} }

  subject { described_class.new config }

  describe '#tenant_for' do
    let(:env) { double 'env' }

    it 'returns the same tenant for any env' do
      expect(subject.tenant_for(env)).to eq :the_tenant
    end
  end

end
