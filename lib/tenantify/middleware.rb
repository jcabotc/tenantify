require 'tenantify/tenant'
require 'tenantify/middleware/builder'

module Tenantify
  # Rack middleware responsible for setting the tenant during the http request.
  #
  # This middleware builds a set of strategies from the given configuration, and
  # sets the tenant returned from those strategies.
  class Middleware
    # Constructor.
    #
    # @param [#call] the Rack application
    # @param [Tenantify::Configuration] the Rack application
    def initialize app, config = Tenantify.configuration
      @app    = app
      @config = config
    end

    # Calls the rack middleware.
    #
    # @param [rack_environment] the Rack environment
    # @return [rack_response] the Rack response
    def call env
      tenant = strategies.tenant_for(env)

      Tenant.using(tenant) { app.call(env) }
    end

  private

    attr_reader :app, :config

    def strategies
      @strategies ||= begin
        builder = Builder.new(config)
        builder.call
      end
    end
  end
end
