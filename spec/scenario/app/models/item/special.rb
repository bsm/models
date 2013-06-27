class Item::Special < Item::Base
  attr_protected :employee_id  if Rails::VERSION::MAJOR < 4
end