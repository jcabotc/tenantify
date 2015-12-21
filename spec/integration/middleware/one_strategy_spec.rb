require 'tenantify'

RSpec.describe "One middleware strategy" do

  let(:app) { double 'app' }

  let :config do
    Tenantify::Configuration.new.tap do |config|
      config.strategy :header, :name => "X-Tenant"
    end
  end

  let(:valid_env)   { {"X-Tenant" => "a_tenant"} }
  let(:invalid_env) { {} }

  let(:response) { double 'response' }

  it 'returns a matching tenant or raises_error' do
    middleware = Tenantify::Middleware.new(app, config)

    # Valid env
    expect(app).to receive :call do |env|
      expect(env).to eq env
      expect(Tenantify.current).to eq :a_tenant

      response
    end

    expect(middleware.call(valid_env)).to eq response
  end

end
