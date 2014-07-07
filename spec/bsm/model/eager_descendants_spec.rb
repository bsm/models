require 'spec_helper'

describe Bsm::Model::EagerDescendants do

  before do
    ActiveSupport::Dependencies.clear
  end

  it 'should be includable' do
    Item::Base.included_modules.should include(described_class)
  end

  it 'should pre-load descendants' do
    Item::Base.descendants.size.should eq(2)
  end

end
