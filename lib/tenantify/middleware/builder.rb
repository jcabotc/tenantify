require 'tenantify/middleware/strategies'

strategies_pattern = File.join(File.dirname(__FILE__), "strategies/*.rb")
Dir[strategies_pattern].each { |strategy_file| require strategy_file }

module Tenantify
  class Middleware
    # This class builds all the strategies and injects them into a
    # Strategies object.
    class Builder
      # Invalid strategy specification
      UnknownStrategyError = Class.new(StandardError)

      # Known strategies. They can be specified with a symbol.
      KNOWN_STRATEGIES = {
        :header => Strategies::Header,
        :host   => Strategies::Host
      }

      # @return [Tenantify::Configuration] given configuration.
      attr_reader :config

      # Constructor.
      #
      # @param [Tenantify::Configuration] the tenantify configuration.
      # @param [Hash] a correspondence between strategy names and classes.
      def initialize config, known_strategies: KNOWN_STRATEGIES
        @config           = config
        @known_strategies = known_strategies
      end

      # Builds the Strategies object.
      #
      # @return [Strategies] the strategies object.
      def call
        Strategies.new(strategies)
      end

    private

      attr_reader :known_strategies

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
    end
  end
end
