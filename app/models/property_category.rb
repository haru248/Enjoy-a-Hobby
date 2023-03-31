class PropertyCategory < ApplicationRecord
  belongs_to :inventory_list
  has_many :properties, dependent: :destroy

  validates :category_name, presence: true, uniqueness: { scope: :inventory_list_id }

  def self.find_category(name)
    find_by(category_name: name)
  end

  def edit?
    PropertyCategory.exists?(id: id)
  end
end
