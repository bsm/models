require 'spec_helper'

describe Bsm::Model::EagerDescendants do

  it 'should be includable' do
    Item::Base.included_modules.should include(described_class)
  end

  it 'should pre-load descendants' do
    Item::Base.descendants.should have(2).items
  end

end
