require 'tenantify'

RSpec.describe "Many middleware strategies" do

  let(:app) { double 'app' }

  let :test_strategy do
    Class.new do
      def initialize config
      end

      def tenant_for env
        :the_tenant
      end
    end
  end

  let :config do
    Tenantify::Configuration.new.tap do |config|
      config.strategy test_strategy
    end
  end

  let(:env)      { double 'env' }
  let(:response) { double 'response' }

  it 'returns a matching tenant or raises_error' do
    middleware = Tenantify::Middleware.new(app, config)

    expect(app).to receive :call do |env|
      expect(env).to eq env
      expect(Tenantify.current).to eq :the_tenant

      response
    end

    expect(middleware.call(env)).to eq response
  end

end
