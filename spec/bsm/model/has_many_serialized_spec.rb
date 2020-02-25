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

  it { expect(record).to be_a(described_class) }

  it 'should define readers' do
    expect(record).to respond_to('project_ids')
    expect(record).to respond_to('projects')

    expect(record.project_ids).to eq([])
    expect(record.projects).to eq([])
    expect(record.projects).to be_a(ActiveRecord::Relation)
  end

  it 'should define writers' do
    expect(record).to respond_to('project_ids=')
    expect(record).to respond_to('projects=')
  end

  it 'should allow sanitized ID assignments' do
    record.project_ids = ['', project.id]
    expect(record.project_ids).to eq([project.id])
    record.project_ids = [project.id.to_s]
    expect(record.project_ids).to eq([project.id])
  end

  it 'should allow record assignments' do
    record.projects = project
    expect(record.projects.to_a).to eq([project])
    expect(record.project_ids).to eq([project.id])
  end

  it 'should prevent invalid record assignments' do
    expect { record.projects = ['invalid'] }.to raise_error(ActiveRecord::AssociationTypeMismatch)
  end

  it 'should store references consistently' do
    # Create in order
    project
    project2

    # Assign
    record.project_ids = [project2.id, project.id]
    record.save!
    expect(record.project_ids).to eq([project.id, project2.id])

    record.reload.project_ids = [project2.id, project.id]
    expect(record).not_to be_changed
  end

  it 'should load saved assignment' do
    record.projects = project
    record.save!
    expect(record.reload.projects).to eq([project])
  end
end
