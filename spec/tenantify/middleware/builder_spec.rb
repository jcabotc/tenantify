require 'tenantify/middleware/builder'

RSpec.describe Tenantify::Middleware::Builder do

  let(:strategies_config) { [] }
  let(:config)            { double 'config', :strategies => strategies_config }

  let(:known_strategies) { {} }

  subject { described_class.new config, known_strategies: known_strategies }

  let(:strategies_class) { Tenantify::Middleware::Strategies }
  let(:strategies)       { double 'strategies' }

  describe '#call' do
    context 'with a known strategy' do
      let(:known_strategy_class) { double 'known_strategy_class' }
      let(:known_strategy)       { double 'known_strategy' }
      let(:known_config)         { double 'known_config' }

      let(:strategies_config) { [[:known, known_config]] }
      let(:known_strategies)  { {:known => known_strategy_class} }

      it 'builds it properly' do
        expect(known_strategy_class).to receive(:new).
          with(known_config).and_return(known_strategy)

        expect(strategies_class).to receive :new do |arg|
          expect(arg).to eq [known_strategy]
          strategies
        end

        expect(subject.call).to eq strategies
      end
    end

    context 'with a given strategy' do
      let(:given_strategy_class) { Struct.new(:config) }
      let(:given_config)         { double 'given_config' }

      let(:strategies_config) { [[given_strategy_class, given_config]] }

      it 'builds it properly' do
        expected_strategy = given_strategy_class.new(given_config)

        expect(strategies_class).to receive :new do |arg|
          expect(arg).to eq [expected_strategy]
          strategies
        end

        expect(subject.call).to eq strategies
      end
    end

    context 'with an unknown strategy' do
      let(:strategies_config) { [[123, {}]] }

      it 'raises error' do
        expected_error = described_class::UnknownStrategyError

        expect { subject.call }.to raise_error expected_error
      end
    end
  end

end
