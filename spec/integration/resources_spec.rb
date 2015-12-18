require 'tenantify'

RSpec.describe "Resource creation" do

  it 'changes the current tenant properly' do
    Tenantify.use! :tenant_1
    expect(Tenantify.current).to eq :tenant_1

    Tenantify.using :tenant_2 do
      expect(Tenantify.current).to eq :tenant_2
    end

    expect(Tenantify.current).to eq :tenant_1
  end

end
