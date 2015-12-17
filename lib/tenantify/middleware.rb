require 'tenantify/tenant'
require 'tenantify/middleware/builder'

module Tenantify
  class Middleware

    def initialize app, config
      @app    = app
      @config = config
    end

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
