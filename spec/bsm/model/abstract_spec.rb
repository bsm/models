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

  it 'should evaluate if instance is abstract' do
    Employee.new.should be_abstract_model_instance
    Manager.new.should_not be_abstract_model_instance
  end

  it 'should allow allow custom evaluation of model_instance_abstract?' do
    employee = Employee.new
    employee.stub! :abstract_model_instance? => false
    employee.tap(&:valid?).errors[:base].should be_empty
  end

end
