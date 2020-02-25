require 'spec_helper'

describe Bsm::Model::StiConvertable do
  it 'should be includable' do
    expect(Item::Base.new).to be_a(described_class)
  end

  it 'should have be of a kind' do
    expect(Item::Special.kind).to eq('special')
    expect(Item::Generic.new.kind).to eq('generic')
  end

  it 'should include eager descendants loading' do
    expect(Item::Base.new).to be_a(Bsm::Model::EagerDescendants)
  end

  it 'should query real descendants' do
    expect(Item::Base.real_descendants.size).to eq(2)
  end

  it 'should initialize new objects by kind' do
    expect(Item::Base.new(kind: 'generic')).to be_instance_of(Item::Generic)
  end

  it 'should ignore invalid kinds' do
    expect(Item::Base.new).to be_instance_of(Item::Base)
    expect(Item::Base.new(kind: 'invalid')).to be_instance_of(Item::Base)
    expect(Item::Generic.new(kind: 'invalid')).to be_instance_of(Item::Generic)
    expect(Item::Generic.new(kind: 'special')).to be_instance_of(Item::Generic)
  end

  it 'should revert to fallback-descendant' do
    allow(Item::Base).to receive_messages fallback_descendant: Item::Special
    expect(Item::Base.new).to be_instance_of(Item::Special)
    expect(Item::Base.new(kind: 'invalid')).to be_instance_of(Item::Special)
  end

  it 'should retain other attributes' do
    expect(Item::Base.new(kind: 'special', name: 'Very').name).to eq('Very')
  end

  it 'should retain model scopes in relation clones' do
    manager = Manager.create! name: 'Boss'
    item    = manager.items.limit(10).create! kind: 'generic'
    expect(item).to be_instance_of(Item::Generic)
    expect(item.reload.employee).to eq(manager)
  end

  it 'should provide no-op kind writer on instance level for form compatibility' do
    special = Item::Special.new
    special.kind = 'other'
    expect(special.kind).to eq('special')
  end

  it 'should initialize from action controller parameters' do
    generic = Item::Base.new(ActionController::Parameters.new(kind: 'generic', name: 'Very').permit(:kind, :name))
    expect(generic).to be_instance_of(Item::Generic)
    expect(generic.name).to eq('Very')
  end
end
