require "tenantify/version"

require "tenantify/configuration"
require "tenantify/tenant"
require "tenantify/resource"
require "tenantify/middleware"

module Tenantify
  # Tenantify configuration
  #
  # @return [Configuration] the current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # A helper to configure Tenantify
  #
  # @yield [configuration] Configures tenantify
  def self.configure
    yield configuration
  end

  # An alias to {Tenant::using}
  #
  # @example Run some code on a particular tenant
  #   Tenantify.using :a_tenant do
  #     # some code...
  #   end
  # @see Tenant.using
  def self.using tenant, &block
    Tenant.using(tenant, &block)
  end

  # An alias to {Tenant::use!}
  #
  # @example Change the current tenant
  #   Tenanfify.use! :a_tenant
  #   # using :a_tenant from now on
  # @see Tenant.use!
  def self.use! tenant
    Tenant.use!(tenant)
  end

  # An alias to {Tenant::current}
  #
  # @see Tenant.current
  def self.current
    Tenant.current
  end

  # An alias to {Resource::new}
  #
  # @see Resource
  def self.resource correspondence
    Resource.new(correspondence)
  end
end
