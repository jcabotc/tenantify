module Tenantify
  class Middleware
    class Strategies
      # Strategy to get the tenant from the request host.
      # It expect the tenant name from configuration.
      #
      # @example Using Header strategy:
      #   config = {
      #     :tenant_1 => ["www.domain_a.com", "www.domain_b.com"],
      #     :tenant_2 => ["www.domain_c.com"]
      #   }
      #   strategy = Tenantify::Middleware::Strategies::Host.new(config)
      #
      #   matching_env = {"SERVER_NAME" => "www.domain_b.com"}
      #   strategy.tenant_for(matching_env) # => :tenant_1
      #
      #   not_matching_env = {"SERVER_NAME" => "www.another_domain.com"}
      #   strategy.tenant_for(not_matching_env) # => nil
      class Host
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
          host   = env["SERVER_NAME"]
          tenant = correspondence[host]

          tenant.to_sym if tenant
        end

      private

        attr_reader :config

        def correspondence
          @correspondence ||= config.reduce Hash.new do |result, (tenant, domains)|
            result.merge! correspondence_for(tenant, domains)
          end
        end

        def correspondence_for tenant, domains
          domains.reduce Hash.new do |result, domain|
            result.merge! domain => tenant
          end
        end
      end
    end
  end
end
