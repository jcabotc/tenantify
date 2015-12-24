module Tenantify
  # It stores a configuration for {Tenantify::Middleware}.
  class Configuration
    # All configured strategies in order of priority.
    #
    # @return [Array<strategy_config>] a collection of strategy configurations.
    attr_reader :strategies

    # Constructor.
    def initialize
      @strategies = []
    end

    # Adds a new strategy for the Tenantify middleware. The order the strategies
    # are added is the priority order they have to match the tenant.
    #
    # @param [Symbol, Class] the name of a known strategy or a custom strategy
    #   class.
    # @param [Hash] strategy configuration.
    # @return [Array<strategy_config>] a collection of strategy configurations.
    def strategy name_or_class, strategy_config = {}
      strategies << [name_or_class, strategy_config]
    end
  end
end
