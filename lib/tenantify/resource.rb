module Tenantify

  # The {Tenantify::Resource} class encapsulates a set of resources
  # (one per tenant) that are seen as a single logical resource from
  # the application's business logic.
  #
  # @example A tenantified database (for tenants "foo" and "bar"):
  #   foo_db = Database.new(:host => host_1, :port => port_1)
  #   bar_db = Database.new(:host => host_1, :port => port_1)
  #
  #   mapping  = {"foo" => foo_db, "bar" => bar_db}
  #   resource = Tenantify::Resource.new(mapping)
  #
  #   Tenantify.using("foo") do
  #     resource.current # => foo_db
  #   end
  #   Tenantify.using("bar") do
  #     resource.current # => bar_db
  #   end
  class Resource
    include Enumerable

    MissingResourceError = Class.new(StandardError)

    # Creates a new tenantified resource.
    #
    # @param [Hash] a correspondence between tenants and resources
    def initialize mapping
      @mapping = mapping
    end

    # Returns the resource for the current tenant or raises
    # MissingResourceError if it does not exist.
    #
    # @return the resource for the current tenant
    def current
      mapping.fetch(Tenantify.current) { raise_error }
    end

    # Returns the mapping between tenants and resources.
    #
    # @return [Hash] a map between tenants and resources
    def all
      mapping
    end

    # Yields each mapping (tenant, resource) pair
    #
    # @yield (tenant, resource) pairs
    def each &block
      mapping.each &block
    end

  private

    def raise_error
      raise MissingResourceError, "Missing resource for tenant: #{Tenantify.current.inspect}"
    end

    attr_reader :mapping

  end
end
