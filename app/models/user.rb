class User < ApplicationRecord
  authenticates_with_sorcery!
  
  has_many :presets
  has_many :inventory_lists

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :user_name, presence: true, length: { maximum: 20 }
end
