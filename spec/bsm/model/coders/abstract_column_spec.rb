require 'spec_helper'

describe Bsm::Model::Coders::AbstractColumn do

  subject do
    described_class.new Hash
  end

  let :basic do
    described_class.new
  end

  its(:object_class) { should == Hash }

end