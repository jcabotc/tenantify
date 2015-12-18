require 'tenantify/tenant'

module Tenantify
  class Resource
    include Enumerable

    def initialize correspondence
      @correspondence = correspondence
    end

    def current
      correspondence.fetch(Tenant.current)
    end

    def all
      correspondence
    end

    def each &block
      correspondence.each &block
    end

  private

    attr_reader :correspondence

  end
end
