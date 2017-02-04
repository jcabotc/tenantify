require 'tenantify'
require 'tenantify/resource'

RSpec.describe Tenantify::Resource do

  let(:tenant_1) { 'tenant_1' }
  let(:tenant_2) { 'tenant_2' }

  let(:resource_1) { double 'resource_1' }
  let(:resource_2) { double 'resource_2' }

  let :correspondence do
    { tenant_1 => resource_1, tenant_2 => resource_2 }
  end

  subject { described_class.new correspondence }

  describe '#current' do
    it 'returns the current resource' do
      Tenantify.using tenant_2 do
        expect(subject.current).to eq resource_2
      end
    end
  end

  describe '#all' do
    it 'returns the correspondence' do
      expect(subject.all).to eq correspondence
    end
  end

  describe 'enumerable methods' do
    let :expected_collection do
      [ [tenant_1, resource_1], [tenant_2, resource_2] ]
    end

    it 'is a collection of resources' do
      expect(subject.to_a).to eq expected_collection
    end
  end

end
