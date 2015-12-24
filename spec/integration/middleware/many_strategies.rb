require 'tenantify'

RSpec.describe "Many middleware strategies" do

  let(:app) { double 'app' }

  let :hosts_config do
    {:first_tenant  => ["www.host_a.com", "www.host_b.com"],
     :second_tenant => ["www.host_c.com", "www.host_d.com"]}
  end

  let :config do
    Tenantify::Configuration.new.tap do |config|
      config.strategy :header, :name => "X-Tenant"
      config.strategy :host, hosts_config
    end
  end

  let(:env)      { {"SERVER_NAME" => "www.host_c.com"} }
  let(:response) { double 'response' }

  it 'returns a matching tenant' do
    middleware = Tenantify::Middleware.new(app, config)

    expect(app).to receive :call do |env|
      expect(env).to eq env
      expect(Tenantify.current).to eq :second_tenant

      response
    end

    expect(middleware.call(env)).to eq response
  end

end
