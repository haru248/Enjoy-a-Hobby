class Schedule < ApplicationRecord
  belongs_to :user
  belongs_to :inventory_list, optional: true
  belongs_to :purchase_list, optional: true
  has_many :live_times, dependent: :destroy

  validates :schedule_name, presence: true, length: { maximum: 255 }
  validates :venue, length: { maximum: 255 }
  validates :lodging, length: { maximum: 255 }
  validates :memo, length: { maximum: 65535 }

  def self.ransackable_attributes(auth_object = nil)
    ["schedule_name"]
  end
end
