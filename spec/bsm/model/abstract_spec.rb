require 'spec_helper'

describe Bsm::Model::Abstract do

  it 'should be includable' do
    Employee.included_modules.should include(described_class)
  end

  it 'should include validation' do
    Employee.protected_instance_methods.map(&:to_s).should include("must_not_be_abstract")
  end

  it 'should not allow to save abstract records' do
    Employee.new.tap(&:valid?).errors[:base].should == ["Record is abstract"]
    Manager.new.tap(&:valid?).errors[:base].should be_empty
  end

end
