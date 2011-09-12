require 'spec_helper'

describe Bsm::Model::StiConvertable do

  it 'should be includable' do
    Item::Base.new.should be_a(described_class)
  end

  it 'should have be of a kind' do
    Item::Special.kind.should == "special"
    Item::Generic.new.kind.should == "generic"
  end

  it 'should include eager descendants loading' do
    Item::Base.new.should be_a(Bsm::Model::EagerDescendants)
  end

  it 'should query real descendants' do
    Item::Base.should have(2).real_descendants
  end

  it 'should initialize new objects by kind' do
    Item::Base.new(:kind => "generic").should be_a(Item::Generic)
  end

  it 'should ignore invalid kinds' do
    Item::Base.new.should be_a(Item::Base)
    Item::Base.new(:kind => "invalid").should be_a(Item::Base)
    Item::Generic.new(:kind => "invalid").should be_a(Item::Generic)
    Item::Generic.new(:kind => "special").should be_a(Item::Generic)
  end

  it 'should revert to fallback-descendant' do
    Item::Base.stub! :fallback_descendant => Item::Special
    Item::Base.new.should be_a(Item::Special)
    Item::Base.new(:kind => "invalid").should be_a(Item::Special)
  end

  it 'should retain other attributes' do
    Item::Base.new(:kind => "special", :name => "Very").name.should == "Very"
  end

  it 'should respect mass-assignment rules' do
    Item::Base.new(:kind => "generic", :employee_id => 1).employee_id.should == 1
    Item::Base.new(:kind => "special", :employee_id => 1).employee_id.should be_nil
  end

  it 'should respect model scopes' do
    Employee.new.items.new(:kind => "generic").should be_a(Item::Generic)
  end

end
