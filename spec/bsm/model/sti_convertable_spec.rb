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
    Item::Base.real_descendants.size.should eq(2)
  end

  it 'should initialize new objects by kind' do
    Item::Base.new(kind: "generic").should be_instance_of(Item::Generic)
  end

  it 'should ignore invalid kinds' do
    Item::Base.new.should be_instance_of(Item::Base)
    Item::Base.new(kind: "invalid").should be_instance_of(Item::Base)
    Item::Generic.new(kind: "invalid").should be_instance_of(Item::Generic)
    Item::Generic.new(kind: "special").should be_instance_of(Item::Generic)
  end

  it 'should revert to fallback-descendant' do
    Item::Base.stub fallback_descendant: Item::Special
    Item::Base.new.should be_instance_of(Item::Special)
    Item::Base.new(kind: "invalid").should be_instance_of(Item::Special)
  end

  it 'should retain other attributes' do
    Item::Base.new(kind: "special", name: "Very").name.should == "Very"
  end

  it 'should retain model scopes in relation clones' do
    manager = Manager.create! name: "Boss"
    item    = manager.items.limit(10).create! kind: "generic"
    item.should be_instance_of(Item::Generic)
    item.reload.employee.should == manager
  end

  it 'should provide no-op kind writer on instance level for form compatibility' do
    special = Item::Special.new
    special.kind = 'other'
    special.kind.should == 'special'
  end

  it 'should initialize from action controller parameters' do
    generic = Item::Base.new(ActionController::Parameters.new(kind: "generic", name: "Very").permit(:kind, :name))
    generic.should be_instance_of(Item::Generic)
    generic.name.should eq("Very")
  end

end
