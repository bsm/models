require 'spec_helper'

describe Bsm::Model::Editable do

  let :record do
    Manager.create! name: 'Boss', fired: true
  end

  it 'should be includable' do
    expect(Manager.included_modules).to include(described_class)
  end

  it 'should constrain update of records' do
    expect(record.tap(&:valid?).errors[:base]).to eq(['Record cannot be updated'])
    record.fired = false
    expect(record.tap(&:valid?).errors[:base]).to be_empty
  end

  it 'should have an immutable status' do
    expect(record).to be_immutable
    record.fired = false
    expect(record).not_to be_immutable
  end

  it 'should allow to force editable' do
    expect(record).to be_immutable
    record.force_editable = true
    expect(record).not_to be_immutable
  end

end
