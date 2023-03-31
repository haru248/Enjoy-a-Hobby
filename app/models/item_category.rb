class ItemCategory < ApplicationRecord
  belongs_to :preset
  has_many :preset_items, dependent: :destroy

  validates :item_category_name, presence: true, uniqueness: { scope: :preset_id }

  def edit?
    ItemCategory.exists?(id: id)
  end
end
