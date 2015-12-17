RSpec.describe Tenantify::VERSION do

  subject { Tenantify::VERSION }

  it 'has semantic format' do
    expect(subject).to match /\A\d+\.\d+\.\d+\z/
  end

end
