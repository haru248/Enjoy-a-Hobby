class InventoryList < ApplicationRecord
  belongs_to :user
  has_many :property_categories, dependent: :destroy
  has_many :schedules, dependent: :nullify

  validates :inventory_list_name, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    ['inventory_list_name']
  end
end
