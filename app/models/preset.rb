class Preset < ApplicationRecord
  belongs_to :user
  has_many :item_categories, dependent: :destroy

  validates :preset_name, presence: true, length: { maximum: 255 }

  def create_default_category(kinds)
    item_categories.create!(item_category_name: I18n.t("default.item_category.#{kinds}_category"))
  end

  def self.ransackable_attributes(auth_object = nil)
    ['preset_name']
  end
end
