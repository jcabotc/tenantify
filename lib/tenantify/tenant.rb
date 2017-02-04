module Tenantify

  # Responsible for managing the current tenant. All useful methods {#using},
  # {#use!}, and {#current} have aliases at {Tenantify} module.
  #
  # == Threading Notes
  # The {Tenantify::Tenant} module uses thread variables to store the current
  # tenant. This means that when a new thread is spawned, the tenant has to
  # be set manually.
  module Tenant

    # Runs the given block for a tenant.
    #
    # @param [String] the tenant to run the code for.
    # @yield the code to run.
    # @return the returning value of the block.
    #
    # @example Getting data from a storage of a particular tenant:
    #   data = Tenant.using "the_tenant" do
    #     Storage.current.get_data
    #   end
    def self.using tenant
      original_tenant = Thread.current.thread_variable_get(:tenant)

      Thread.current.thread_variable_set(:tenant, tenant)
      yield
    ensure
      Thread.current.thread_variable_set(:tenant, original_tenant)
    end

    # Sets the given tenant from now on.
    #
    # @param [String] the tenant to set.
    # @return [String] the set tenant.
    def self.use! tenant
      Thread.current.thread_variable_set(:tenant, tenant)
    end

    # Returns the current tenant.
    #
    # @return [String] the current tenant.
    def self.current
      Thread.current.thread_variable_get(:tenant)
    end

  end
end
