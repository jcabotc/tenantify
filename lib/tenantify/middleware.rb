require 'tenantify/tenant'
require 'tenantify/middleware/builder'

module Tenantify
  class Middleware

    NoMatchingStrategyError = Class.new(StandardError)

    def initialize app, config
      @app    = app
      @config = config
    end

    def call env
      Tenant.using tenant_for(env) do
        app.call(env)
      end
    end

  private

    attr_reader :app, :config

    def tenant_for env
      find_tenant_for(env) or raise_error(env)
    end

    def find_tenant_for env
      lazy_stategies.
        map { |strategy| strategy.tenant_for(env) }.
        find { |tenant| tenant }
    end

    def lazy_stategies
      @lazy_stategies ||= strategies.lazy
    end

    def strategies
      builder = Builder.new(config)
      builder.call
    end

    def raise_error env
      raise NoMatchingStrategyError.new(env.inspect)
    end

  end
end
