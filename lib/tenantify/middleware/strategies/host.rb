module Tenantify
  class Middleware
    class Strategies
      class Host

        def initialize config
          @config = config
        end

        def tenant_for env
          host   = env["SERVER_NAME"]
          tenant = correspondence[host]

          tenant.to_sym if tenant
        end

      private

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

        attr_reader :config

      end
    end
  end
end
