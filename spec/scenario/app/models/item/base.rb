class Item::Base < ActiveRecord::Base
  self.table_name = 'items'
  include Bsm::Model::StiConvertable
  belongs_to :employee
end
