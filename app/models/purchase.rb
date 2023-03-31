class Purchase < ApplicationRecord
  belongs_to :purchase_list

  validates :purchase_name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  def edit?
    Purchase.exists?(id: id)
  end
end
