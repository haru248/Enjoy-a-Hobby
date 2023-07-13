class PurchaseList < ApplicationRecord
  belongs_to :user
  has_many :purchases, dependent: :destroy
  has_many :schedules, dependent: :nullify

  validates :purchase_list_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['purchase_list_name']
  end
end
