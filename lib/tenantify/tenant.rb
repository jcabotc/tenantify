module Tenantify
  # Responsible for managing the current tenant. All useful methods {#using},
  # {#use!}, and {#current} have aliases at {Tenantify} module.
  #
  # == Threading Notes
  module Tenant

    def self.using tenant
      original_tenant = Thread.current.thread_variable_get(:tenant)

      Thread.current.thread_variable_set(:tenant, tenant)
      yield
    ensure
      Thread.current.thread_variable_set(:tenant, original_tenant)
    end

    def self.use! tenant
      Thread.current.thread_variable_set(:tenant, tenant)
    end

    def self.current
      Thread.current.thread_variable_get(:tenant)
    end

  end
end
