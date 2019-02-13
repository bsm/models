require 'spec_helper'

describe Bsm::Model::Coders::JsonColumn do

  subject do
    described_class.new Hash
  end

  let :basic do
    described_class.new
  end

  it 'should dump objects' do
    expect(subject.dump(a: 1, b: 2)).to be_instance_of(String)
  end

  it 'should create quotable strings objects' do
    expect(ActiveRecord::Base.connection.quote(subject.dump(a: 'x', b: 2, c: [3]))).to be_instance_of(String)
  end

  it 'should load objects' do
    expect(subject.load(subject.dump(a: 1, b: 2))).to eq('a' => 1, 'b' => 2)
    expect(subject.load(subject.dump(a: 'x', b: 2, c: [3]))).to eq('a' => 'x', 'b' => 2, 'c' => [3])
  end

  it 'should correctly convert load blanks' do
    expect(subject.load(nil)).to eq({})
    expect(subject.load('')).to eq({})
    expect(basic.load(nil)).to be_nil
  end

  it 'should correctly convert blanks' do
    expect(subject.load(nil)).to eq({})
    expect(basic.load(nil)).to be_nil
  end

  it 'should not fail on incorrect inputs' do
    expect(subject.load('INVALID')).to eq({})
    expect(subject.load('')).to eq({})
    expect(basic.load('INVALID')).to eq('INVALID')
  end

  it 'should load already decoded values' do
    expect(subject.load(a: 1, b: 2)).to eq(a: 1, b: 2)
  end

  it 'should raise errrors on type missmatch' do
    expect do
      subject.load(subject.dump([1, 2]))
    end.to raise_error(ActiveRecord::SerializationTypeMismatch, /was supposed to be a Hash, but was a Array/)
  end

end
