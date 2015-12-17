module Tenantify
  class Middleware
    class Strategies

      NotMatchingStrategyError = Class.new(StandardError)

      def initialize strategies
        @strategies = strategies
      end

      def tenant_for env
        find_tenant_for(env) or raise_error(env)
      end

    private

      def find_tenant_for env
        lazy_strategies.
          map { |strategy| strategy.tenant_for(env) }.
          find { |tenant| tenant }
      end

      def raise_error env
        raise NotMatchingStrategyError.new(env.inspect)
      end

      def lazy_strategies
        @lazy_strategies ||= strategies.lazy
      end

      attr_reader :strategies

    end
  end
end
