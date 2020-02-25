require 'spec_helper'

describe Bsm::Model::Abstract do
  it 'should be includable' do
    expect(Employee.included_modules).to include(described_class)
  end

  it 'should include validation' do
    expect(Employee.protected_instance_methods.map(&:to_s)).to include('must_not_be_abstract')
  end

  it 'should not allow to save abstract records' do
    expect(Employee.new.tap(&:valid?).errors[:base]).to eq(['Record is abstract'])
    expect(Manager.new.tap(&:valid?).errors[:base]).to be_empty
  end

  it 'should evaluate if instance is abstract' do
    expect(Employee.new.send(:abstract_model_instance?)).to eq(true)
    expect(Manager.new.send(:abstract_model_instance?)).to eq(false)
  end

  it 'should allow allow custom evaluation of model_instance_abstract?' do
    employee = Employee.new
    allow(employee).to receive_messages abstract_model_instance?: false
    expect(employee.tap(&:valid?).errors[:base]).to be_empty
  end
end
