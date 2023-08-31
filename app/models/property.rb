class Property < ApplicationRecord
  belongs_to :property_category

  validates :property_name, presence: true, length: { maximum: 255 }

  def edit?
    Property.exists?(id: id)
  end
end
