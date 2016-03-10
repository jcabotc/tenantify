module Tenantify
  class Middleware
    class Strategies
      # Strategy to get the tenant from a request header.
      # It expect the tenant name from configuration.
      #
      # @example Using Header strategy:
      #   config   = {:name => "X-Tenant"}
      #   strategy = Tenantify::Middleware::Strategies::Header.new(config)
      #
      #   matching_env = {"X-Tenant" => "a_tenant"}
      #   strategy.tenant_for(matching_env) # => :a_tenant
      #
      #   not_matching_env = {"X-Another-Header" => "something"}
      #   strategy.tenant_for(not_matching_env) # => nil
      class Header
        # No header name provided.
        NoHeaderNameError = Class.new(StandardError)

        # Constructor.
        #
        # @param [Hash] the strategy configuration.
        # @option :name the name of the header.
        def initialize config
          @config = config
        end

        # Finds a tenant for the given env.
        #
        # @param [rack_environment] the rack environment.
        # @return [Symbol, nil] the found tenant of nil.
        def tenant_for env
          env[header_name]
        end

      private

        attr_reader :config

        def header_name
          @header_name ||= config.fetch(:name) { raise_error }
        end

        def raise_error
          raise NoHeaderNameError
        end
      end
    end
  end
end
