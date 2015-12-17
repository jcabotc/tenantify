require 'yaml'

module Tenantify
  class Configuration

    attr_reader :strategies

    def initialize
      @strategies = []
    end

    def strategy name_or_class, strategy_config
      strategies << [name_or_class, strategy_config]
    end

  end
end
