class PresetItem < ApplicationRecord
  belongs_to :item_category

  validates :preset_item_name, presence: true
  
  def edit?
    PresetItem.exists?(id: id)
  end
end
