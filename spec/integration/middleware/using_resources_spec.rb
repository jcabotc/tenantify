require 'tenantify'

RSpec.describe "Using a resource with the middleware" do

  let(:app) { double 'app' }

  let :test_strategy do
    Class.new do
      def initialize config
      end

      def tenant_for env
        :a_tenant
      end
    end
  end

  let :config do
    Tenantify::Configuration.new.tap do |config|
      config.strategy test_strategy
    end
  end

  let(:resource_1) { double 'resource_1' }
  let(:resource_2) { double 'resource_2' }

  let :resource do
    Tenantify.resource :a_tenant       => resource_1,
                       :another_tenant => resource_2
  end

  let(:env)      { double 'env' }
  let(:response) { double 'response' }

  it 'returns a matching tenant or raises_error' do
    middleware = Tenantify::Middleware.new(app, config)

    expect(app).to receive :call do |env|
      expect(env).to eq env
      expect(resource.current).to eq resource_1

      response
    end

    expect(middleware.call(env)).to eq response
  end

end
