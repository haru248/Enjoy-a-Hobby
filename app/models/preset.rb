class Preset < ApplicationRecord
  belongs_to :user
  has_many :item_categories, dependent: :destroy

  validates :preset_name, presence: true

  private

  def self.ransackable_attributes(auth_object = nil)
    ['preset_name']
  end
end
