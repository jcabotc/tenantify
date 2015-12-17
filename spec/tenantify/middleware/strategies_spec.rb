require 'tenantify/middleware/strategies'

RSpec.describe Tenantify::Middleware::Strategies do

  let(:strategies) { [] }

  subject { described_class.new strategies }

  describe '#tenant_for' do
    let(:env) { double 'env' }

    context 'when some strategy matches' do
      let(:strategy_1) { double 'strategy_1' }
      let(:strategy_2) { double 'strategy_2' }
      let(:strategy_3) { double 'strategy_2' }

      let(:strategies) { [strategy_1, strategy_2, strategy_3] }

      it 'does not check remaining strategies' do
        expect(strategy_1).to receive(:tenant_for).
          with(env).and_return(nil)

        expect(strategy_2).to receive(:tenant_for).
          with(env).and_return(:a_tenant)

        expect(strategy_3).not_to receive(:tenant_for)

        expect(subject.tenant_for(env)).to eq :a_tenant
      end
    end

    context 'when none strategy matches' do
      let(:error) { described_class::NotMatchingStrategyError }

      it 'raises error' do
        expect{subject.tenant_for(env)}.to raise_error error
      end
    end
  end

end
