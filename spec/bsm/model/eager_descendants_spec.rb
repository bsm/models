require 'spec_helper'

describe Bsm::Model::EagerDescendants do
  before do
    ActiveSupport::Dependencies.clear
  end

  it 'is includable' do
    expect(Item::Base.included_modules).to include(described_class)
  end

  it 'pre-loads descendants' do
    expect(Item::Base.descendants.size).to eq(2)
  end
end
