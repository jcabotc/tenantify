require 'tenantify/tenant'

RSpec.describe Tenantify::Tenant do

  subject { Tenantify::Tenant }

  def current_tenant
    Thread.current[:tenant]
  end

  def set_tenant tenant
    Thread.current[:tenant] = tenant
  end

  describe '.using' do
    it 'changes the current tenant in the block' do
      set_tenant 'original_value'

      subject.using 'another_tenant' do
        expect(current_tenant).to eq 'another_tenant'
      end

      expect(current_tenant).to eq 'original_value'
    end
  end

  describe '.use!' do
    it 'changes the current tenant permanently' do
      subject.use! 'a_tenant'

      expect(current_tenant).to eq 'a_tenant'
    end
  end

  describe '.current' do
    it 'returns the current tenant' do
      set_tenant 'the_tenant'

      expect(subject.current).to eq current_tenant
    end
  end

end
