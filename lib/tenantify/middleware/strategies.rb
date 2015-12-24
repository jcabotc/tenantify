module Tenantify
  class Middleware
    # Responsible for finding the tenant for the given env.
    #
    # It iterates the strategies given to the constructor until it finds
    # one that returns a tenant.
    #
    # == Default strategy
    # When there is no matching strategy for the current environment
    # a NotMatchingStrategyError is raised. To avoid this behaviour and
    # use a particular tenant by default a Default strategy is provided.
    #
    # @example Configuring a tenant by default:
    #   Tenantify.configure do |config|
    #     # your strategies
    #
    #     config.strategy :default, :tenant => :my_default_tenant
    #   end
    class Strategies
      # None strategy found a valid tenant for the given environment
      NotMatchingStrategyError = Class.new(StandardError)

      # Constructor. It receives all strategies in order of precedence.
      #
      # @param [<#tenant_for>] enumerable of strategies
      def initialize strategies
        @strategies = strategies
      end

      # Find a tenant for the current env.
      #
      # @param [rack_environment] current env.
      # @return [Symbol] returns the matching tenant.
      def tenant_for env
        find_tenant_for(env) or raise_error(env)
      end

    private

      attr_reader :strategies

      def find_tenant_for env
        lazy_strategies.
          map { |strategy| strategy.tenant_for(env) }.
          find { |tenant| tenant }
      end

      def lazy_strategies
        @lazy_strategies ||= strategies.lazy
      end

      def raise_error env
        raise NotMatchingStrategyError.new(env.inspect)
      end
    end
  end
end
