require 'spec_helper'

describe Bsm::Model::HasManySerialized do
  let :record do
    Manager.create!
  end

  let :project do
    Project.new.tap(&:save!)
  end

  let :project2 do
    Project.new.tap(&:save!)
  end

  it { record.should be_a(described_class) }

  it 'should define serialize attributes' do
    record.class.serialized_attributes['project_ids'].should be_a(Bsm::Model::Coders::JsonColumn)
  end

  it 'should define readers' do
    record.should respond_to('project_ids')
    record.should respond_to('projects')

    record.project_ids.should == []
    record.projects.should == []
    record.projects.should be_a(ActiveRecord::Relation)
  end

  it 'should define writers' do
    record.should respond_to('project_ids=')
    record.should respond_to('projects=')
  end

  it 'should allow sanitized ID assignments' do
    record.project_ids = ["", project.id]
    record.project_ids.should == [project.id]
    record.project_ids = [project.id.to_s]
    record.project_ids.should == [project.id]
  end

  it 'should allow record assignments' do
    record.projects = project
    record.projects.to_a.should == [project]
    record.project_ids.should == [project.id]
  end

  it 'should prevent invalid record assignments' do
    -> { record.projects = ['invalid'] }.should raise_error(ActiveRecord::AssociationTypeMismatch)
  end

  it 'should store references consistently' do
    # Create in order
    project
    project2

    # Assign
    record.project_ids = [project2.id, project.id]
    record.save!
    record.project_ids.should == [project.id, project2.id]

    record.reload.project_ids = [project2.id, project.id]
    record.should_not be_changed
  end

  it 'should load saved assignment' do
    record.projects = project
    record.save!
    record.reload.projects.should == [project]
  end

end