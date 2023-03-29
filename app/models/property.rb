class Property < ApplicationRecord
  belongs_to :property_category

  validates :property_name, presence: true
end
