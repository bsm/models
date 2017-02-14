ENV["RAILS_ENV"] ||= 'test'

$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler/setup'

require 'active_support'
require 'active_record'
require 'action_controller'
require 'rspec'
require 'rspec/its'
require 'bsm/model'

require File.expand_path('../scenario/config/application', __FILE__)
Bsm::Model::TestScenario.initialize!
ActiveRecord::Base.configurations["test"] = { 'adapter' => 'sqlite3', 'database' => ":memory:" }


RSpec.configure do |c|
  c.expect_with :rspec do |c|
    c.syntax = [:expect, :should]
  end
  c.mock_with :rspec do |c|
    c.syntax = [:expect, :should]
  end
  c.before(:all) do
    base = ActiveRecord::Base
    base.establish_connection(:test)
    base.connection.create_table :employees do |t|
      t.string :type
      t.string :name
      t.boolean :fired, :null => false, :default => false
      t.string :project_ids
    end
    base.connection.create_table :items do |t|
      t.integer :employee_id
      t.string :type
      t.string :name
    end
    base.connection.create_table :projects do |t|
    end
  end
end

class Project < ActiveRecord::Base
end

class Employee < ActiveRecord::Base
  include Bsm::Model::Abstract
  has_many :items, :class_name => "Item::Base"

  include Bsm::Model::HasManySerialized
  has_many_serialized :projects
end

class Manager < Employee
  include Bsm::Model::Editable
  include Bsm::Model::Deletable

  def editable?
    !fired?
  end

  def deletable?
    fired?
  end
end
