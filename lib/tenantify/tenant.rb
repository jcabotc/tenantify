module Tenantify
  module Tenant

    def self.using tenant
      original_value = Thread.current[:tenant]

      Thread.current[:tenant] = tenant
      yield
    ensure
      Thread.current[:tenant] = original_value
    end

    def self.use! tenant
      Thread.current[:tenant] = tenant
    end

    def self.current
      Thread.current[:tenant]
    end

  end
end
