require 'spec_helper'

describe Bsm::Model::Editable do

  let :record do
    Manager.create! :name => "Boss", :fired => true
  end

  it 'should be includable' do
    Manager.included_modules.should include(described_class)
  end

  it 'should constrain update of records' do
    record.tap(&:valid?).errors[:base].should == ["Record cannot be updated"]
    record.fired = false
    record.tap(&:valid?).errors[:base].should be_empty
  end

  it 'should have an immutable status' do
    record.should be_immutable
    record.fired = false
    record.should_not be_immutable
  end

  it 'should allow to force editable' do
    record.should be_immutable
    record.force_editable = true
    record.should_not be_immutable
  end

end
