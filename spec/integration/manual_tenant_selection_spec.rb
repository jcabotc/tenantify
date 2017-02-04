require 'tenantify'

RSpec.describe "Manual tenant selection" do

  it 'changes the current tenant properly' do
    Tenantify.use!("tenant_1")
    expect(Tenantify.current).to eq "tenant_1"

    Tenantify.using("tenant_2") do
      expect(Tenantify.current).to eq "tenant_2"

      Tenantify.use!("tenant_3")
      expect(Tenantify.current).to eq "tenant_3"
    end

    expect(Tenantify.current).to eq "tenant_1"
  end

end
