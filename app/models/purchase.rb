class Purchase < ApplicationRecord
  belongs_to :purchase_list

  validates :purchase_name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2147483647 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 2147483647 }

  def edit?
    Purchase.exists?(id: id)
  end
end
