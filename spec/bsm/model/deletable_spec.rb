require 'spec_helper'

describe Bsm::Model::Deletable do

  let :record do
    Manager.create! :name => "Boss"
  end

  it 'should be includable' do
    Manager.included_modules.should include(described_class)
  end

  it 'should constrain deletion of records' do
    record.tap(&:destroy).should_not be_destroyed
    record.fired = true
    record.tap(&:destroy).should be_destroyed
  end

end
