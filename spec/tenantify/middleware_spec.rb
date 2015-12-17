require 'tenantify/middleware'

RSpec.describe Tenantify::Middleware do

  let(:app)    { double 'app' }
  let(:config) { double 'config' }

  subject { described_class.new app, config }

  let(:strategies) { double 'strategies' }
  let(:builder)    { double 'builder', :call => strategies }

  before do
    allow(described_class::Builder).to receive(:new).
      with(config).and_return(builder)
  end

  describe '#call' do
    let(:env)      { double 'env' }
    let(:response) { double 'response' }

    it 'calls the app with the proper tenant' do
      expect(strategies).to receive(:tenant_for).
        with(env).and_return(:a_tenant)

      expect(app).to receive :call do |given_env|
        expect(given_env).to eq env
        expect(Tenantify::Tenant.current).to eq :a_tenant

        response
      end

      expect(subject.call(env)).to eq response
    end
  end

end
