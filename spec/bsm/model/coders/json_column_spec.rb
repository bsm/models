require 'spec_helper'

describe Bsm::Model::Coders::JsonColumn do

  subject do
    described_class.new Hash
  end

  let :basic do
    described_class.new
  end

  it 'should dump objects' do
    subject.dump(a: 1, b: 2).should be_instance_of(String)
    subject.dump(a: 1, b: 2).encoding.to_s.should == "US-ASCII"
  end

  it 'should create quotable strings objects' do
    ActiveRecord::Base.connection.quote(subject.dump(a: "x", b: 2, c: [3])).should be_instance_of(String)
  end

  it 'should load objects' do
    subject.load(subject.dump(a: 1, b: 2)).should == { "a" => 1, "b" => 2 }
    subject.load(subject.dump(a: "x", b: 2, c: [3])).should == { "a" => "x", "b" => 2, "c" => [3] }
  end

  it 'should correctly convert load blanks' do
    subject.load(nil).should == {}
    subject.load("").should == {}
    basic.load(nil).should == nil
  end

  it 'should correctly convert blanks' do
    subject.load(nil).should == {}
    basic.load(nil).should == nil
  end

  it 'should not fail on incorrect inputs' do
    subject.load("INVALID").should == {}
    subject.load("").should == {}
    basic.load("INVALID").should == "INVALID"
  end

  it 'should raise errrors on type missmatch' do
    lambda {
      subject.load(subject.dump([1, 2]))
    }.should raise_error(ActiveRecord::SerializationTypeMismatch, /was supposed to be a Hash, but was a Array/)
  end

end