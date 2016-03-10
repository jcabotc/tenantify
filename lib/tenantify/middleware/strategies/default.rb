module Tenantify
  class Middleware
    class Strategies
      # Strategy to return always the same tenant.
      #
      # @example Using Default strategy:
      #   config   = {:tenant => :a_tenant}
      #   strategy = Tenantify::Middleware::Strategies::Default.new(config)
      #
      #   env = {} # any environment
      #   strategy.tenant_for(env) # => :a_tenant
      class Default
        # No tenant given.
        NoTenantGivenError = Class.new(StandardError)

        # Constructor.
        #
        # @param [Hash] the strategy configuration.
        # @option :tenant the tenant to return
        def initialize config
          @config = config
        end

        # Finds a tenant for the given env.
        #
        # @param [rack_environment] the rack environment.
        # @return [Symbol, nil] the found tenant of nil.
        def tenant_for _env
          tenant
        end

      private

        attr_reader :config

        def tenant
          @tenant ||= config.fetch(:tenant) { raise_error }
        end

        def raise_error
          raise NoTenantGivenError
        end
      end
    end
  end
end
