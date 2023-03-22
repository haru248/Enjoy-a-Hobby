module PresetItemsHelper
  def preset_item__exists?(preset_item)
    PresetItem.exists?(id: preset_item.id)
  end
end
