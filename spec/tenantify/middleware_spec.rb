require 'tenantify/middleware'

RSpec.describe Tenantify::Middleware do

  let(:app)    { double 'app' }
  let(:config) { double 'config' }

  subject { described_class.new app, config }

  let(:strategies) { [] }
  let(:builder)    { double 'builder', :call => strategies }

  before do
    allow(described_class::Builder).to receive(:new).
      with(config).and_return(builder)
  end

  describe '#call' do
    let(:env) { double 'env' }

    context 'with a matching strategy' do
      let(:response) { double 'response' }

      let(:strategy_1) { double 'strategy_1' }
      let(:strategy_2) { double 'strategy_2' }
      let(:strategy_3) { double 'strategy_3' }

      let(:strategies) { [strategy_1, strategy_2, strategy_3] }

      it 'returns the first matched tenant' do
        expect(strategy_1).to receive(:tenant_for).
          with(env).and_return(nil)

        expect(strategy_2).to receive(:tenant_for).
          with(env).and_return(:a_tenant)

        expect(strategy_3).not_to receive(:tenant_for)

        expect(app).to receive :call do |env|
          expect(env).to eq env
          expect(Tenantify::Tenant.current).to eq :a_tenant

          response
        end

        expect(subject.call(env)).to eq response
      end
    end

    context 'with no matching strategy' do
      it 'raises error' do
        expected_error = described_class::NoMatchingStrategyError

        expect { subject.call(env) }.to raise_error expected_error
      end
    end
  end

end
