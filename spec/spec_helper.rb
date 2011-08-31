ENV["RAILS_ENV"] ||= 'test'

$: << File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require :default, :test

require 'active_support'
require 'active_record'
require 'rspec'
require 'bsm_models'

ActiveRecord::Base.configurations["test"] = { 'adapter' => 'sqlite3', 'database' => ":memory:" }

RSpec.configure do |c|
  c.before(:all) do
    base = ActiveRecord::Base
    base.establish_connection(:test)
    base.connection.create_table :employees do |t|
      t.string :type
      t.string :name
      t.boolean :fired, :null => false, :default => false
    end
  end
end

class Employee < ActiveRecord::Base
  include Bsm::Model::Abstract
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
