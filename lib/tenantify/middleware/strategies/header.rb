module Tenantify
  class Middleware
    class Strategies
      class Header

        NoHeaderNameError = Class.new(StandardError)

        def initialize config
          @config = config
        end

        def tenant_for env
          tenant = env[header_name]

          tenant.to_sym if tenant
        end

      private

        def header_name
          @header_name ||= config.fetch(:name) { raise_error }
        end

        def raise_error
          raise NoHeaderNameError
        end

        attr_reader :config

      end
    end
  end
end
