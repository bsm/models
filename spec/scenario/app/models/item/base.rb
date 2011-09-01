class Item::Base < ActiveRecord::Base
  set_table_name 'items'
  include Bsm::Model::StiConvertable
end