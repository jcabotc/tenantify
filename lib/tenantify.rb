require "tenantify/version"

require "tenantify/tenant"
require "tenantify/resource"

module Tenantify

  # An alias to {Tenantify::Tenant::using}
  #
  # @example Run some code on a particular tenant
  #   Tenantify.using "a_tenant" do
  #     # some code...
  #   end
  # @see Tenantify::Tenant.using
  def self.using tenant, &block
    Tenant.using(tenant, &block)
  end

  # An alias to {Tenantify::Tenant::use!}
  #
  # @example Change the current tenant
  #   Tenanfify.use! "a_tenant"
  #   # using "a_tenant" from now on
  # @see Tenantify::Tenant.use!
  def self.use! tenant
    Tenant.use!(tenant)
  end

  # An alias to {Tenantify::Tenant::current}
  #
  # @see Tenantify::Tenant.current
  def self.current
    Tenant.current
  end

  # An alias to {Tenantify::Resource::new}
  #
  # @see Tenantify::Resource
  def self.resource correspondence
    Resource.new(correspondence)
  end

end
