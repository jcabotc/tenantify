module Tenantify
  class Middleware
    class Builder

      UnknownStrategyError = Class.new(StandardError)

      KNOWN_STRATEGIES = {}

      attr_reader :config

      def initialize config, known_strategies: KNOWN_STRATEGIES
        @config           = config
        @known_strategies = known_strategies
      end

      def call
        strategies_config.map do |(name_or_class, strategy_config)|
          strategy_class_for(name_or_class).new(strategy_config)
        end
      end

    private

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
