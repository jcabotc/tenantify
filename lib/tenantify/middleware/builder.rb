require 'tenantify/middleware/strategies'

strategies_pattern = File.join(File.dirname(__FILE__), "strategies/*.rb")
Dir[strategies_pattern].each { |strategy_file| require strategy_file }

module Tenantify
  class Middleware
    class Builder

      UnknownStrategyError = Class.new(StandardError)

      KNOWN_STRATEGIES = {
        :header => Strategies::Header,
        :host   => Strategies::Host
      }

      attr_reader :config

      def initialize config, known_strategies: KNOWN_STRATEGIES
        @config           = config
        @known_strategies = known_strategies
      end

      def call
        Strategies.new(strategies)
      end

    private

      def strategies
        strategies_config.map do |(name_or_class, strategy_config)|
          strategy_class_for(name_or_class).new(strategy_config)
        end
      end

      def strategy_class_for name_or_class
        case name_or_class
          when Class          then name_or_class
          when Symbol, String then known_strategies.fetch(name_or_class.to_sym)
          else raise UnknownStrategyError.new(name_or_class.inspect)
        end
      end

      def strategies_config
        config.strategies
      end

      attr_reader :known_strategies

    end
  end
end
