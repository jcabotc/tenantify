require "tenantify/version"

require "tenantify/middleware"
require "tenantify/configuration"
require "tenantify/tenant"

module Tenantify

  # Configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  # Manual tenant management
  def self.using tenant, &block
    Tenant.using(tenant, &block)
  end

  def self.use! tenant
    Tenant.use!(tenant)
  end

  def self.current
    Tenant.current
  end

  # Resources
  def self.resource correspondence
    Resource.new(correspondence)
  end

end
