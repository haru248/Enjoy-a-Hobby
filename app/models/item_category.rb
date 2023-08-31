class ItemCategory < ApplicationRecord
  belongs_to :preset
  has_many :preset_items, dependent: :destroy

  validates :item_category_name, presence: true, uniqueness: { scope: :preset_id }, length: { maximum: 255 }

  def create_default_items(kinds)
    case kinds
    when 'daily'
      item_names = I18n.t([:charger, :mobile_battery, :handkerchief, :tissue, :medicine, :rain_gear], scope: [:default, :daily_item])
      item_names.each do |item_name|
        preset_items.create!(preset_item_name: item_name)
      end
    when 'clothing'
      item_names = I18n.t([:change_clothes, :towel, :cold_weather_gear], scope: [:default, :clothing_item])
      item_names.each do |item_name|
        preset_items.create!(preset_item_name: item_name)
      end
    when 'live'
      item_names = I18n.t([:ticket, :penlight, :battery, :live_T_shirt, :live_towel], scope: [:default, :live_item])
      item_names.each do |item_name|
        preset_items.create!(preset_item_name: item_name)
      end
    when 'valuables'
      item_names = I18n.t([:wallet, :identification, :IC_card, :smart_phone], scope: [:default, :valuables_item])
      item_names.each do |item_name|
        preset_items.create!(preset_item_name: item_name)
      end
    end
  end

  def edit?
    ItemCategory.exists?(id: id)
  end
end
