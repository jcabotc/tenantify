require 'tenantify'

RSpec.describe "Manual tenant selection" do

  def keep_tenant
    original_value = Thread.current[:tenant]
    yield
  ensure
    Thread.current[:tenant] = original_value
  end

  around { |example| keep_tenant { example.run } }

  it 'changes the current tenant properly' do
    Tenantify.use! :tenant_1
    expect(Tenantify.current).to eq :tenant_1

    Tenantify.using :tenant_2 do
      expect(Tenantify.current).to eq :tenant_2
    end

    expect(Tenantify.current).to eq :tenant_1
  end

end
