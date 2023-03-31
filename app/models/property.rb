class Property < ApplicationRecord
  belongs_to :property_category

  validates :property_name, presence: true

  def edit?
    Property.exists?(id: id)
  end
end
