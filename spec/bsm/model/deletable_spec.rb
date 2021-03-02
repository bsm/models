require 'spec_helper'

describe Bsm::Model::Deletable do
  let :record do
    Manager.create! name: 'Boss'
  end

  it 'is includable' do
    expect(Manager.included_modules).to include(described_class)
  end

  it 'constrains deletion of records' do
    expect(record.tap(&:destroy)).not_to be_destroyed
    record.fired = true
    expect(record.tap(&:destroy)).to be_destroyed
  end
end
