require 'tenantify/configuration'

RSpec.describe Tenantify::Configuration do

  subject { described_class.new }

  describe '#strategy and #strategies' do
    it 'stores all strategies and configuration' do
      subject.strategy :strategy_1, :strategy_config_1
      subject.strategy :strategy_2, :strategy_config_2

      expect(subject.strategies).to eq [
        [:strategy_1, :strategy_config_1],
        [:strategy_2, :strategy_config_2]
      ]
    end
  end

end
