class PurchaseList < ApplicationRecord
  belongs_to :user
  has_many :purchases, dependent: :destroy

  validates :purchase_list_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['purchase_list_name']
  end
end
