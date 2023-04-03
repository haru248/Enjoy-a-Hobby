class User < ApplicationRecord
  authenticates_with_sorcery!
  
  has_many :presets, dependent: :destroy
  has_many :inventory_lists, dependent: :destroy
  has_many :purchase_lists, dependent: :destroy

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :user_name, presence: true, length: { maximum: 20 }

  def create_default_preset
    daily_preset = presets.create!(preset_name: I18n.t('default.preset.daily_preset'))
    daily_preset_category = daily_preset.create_default_category('daily')
    daily_preset_category.create_default_items('daily')

    clothing_preset = presets.create!(preset_name: I18n.t('default.preset.clothing_preset'))
    clothing_preset_category = clothing_preset.create_default_category('clothing')
    clothing_preset_category.create_default_items('clothing')

    live_preset = presets.create!(preset_name: I18n.t('default.preset.live_preset'))
    live_preset_category = live_preset.create_default_category('live')
    live_preset_category.create_default_items('live')

    valuables_preset = presets.create!(preset_name: I18n.t('default.preset.valuables_preset'))
    valuables_preset_category = valuables_preset.create_default_category('valuables')
    valuables_preset_category.create_default_items('valuables')
  end
end
