crumb :root do
  if logged_in?
    link t('gretel.mypage'), mypage_path
  else
    link t('gretel.top'), root_path
  end
end

crumb :user_new do
  link t('gretel.user_new')
  parent :root
end

crumb :login do
  link t('gretel.login'), login_path
  parent :root
end

crumb :password_reset_new do
  link t('gretel.password_reset_new')
  parent :login
end

#crumb :terms_of_service do
#  link t('gretel.terms_of_service')
#  parent :root
#end

#crumb :privacy_policy do
#  link t('gretel.privacy_policy')
#  parent :root
#end

#crumb :inquiry do #問い合わせはページ増えるかも
#  link t('gretel.inquiry')
#  parent :root
#end

crumb :preset_index do
  link t('gretel.preset_index'), presets_path
  parent :root
end

crumb :preset_new do
  link t('gretel.preset_new')
  parent :preset_index
end

crumb :preset_show do |preset|
  link t('gretel.preset_show', name: preset.preset_name), preset_path(preset)
  parent :preset_index
end

crumb :preset_edit do |preset|
  link t('gretel.preset_edit')
  parent :preset_show, Preset.find(preset.id)
end

crumb :item_category_index do |preset|
  link t('gretel.item_category_index')
  parent :preset_show, preset
end

crumb :preset_item_new do |preset|
  link t('gretel.preset_item_new')
  parent :preset_show, preset
end

crumb :preset_item_edit do |preset, preset_item|
  link t('gretel.preset_item_edit', name: PresetItem.find(preset_item.id).preset_item_name)
  parent :preset_show, preset
end

crumb :inventory_list_index do
  link t('gretel.inventory_list_index'), inventory_lists_path
  parent :root
end

crumb :inventory_list_new do
  link t('gretel.inventory_list_new')
  parent :inventory_list_index
end

crumb :inventory_list_show do |inventory_list|
  link t('gretel.inventory_list_show', name: inventory_list.inventory_list_name), inventory_list_path(inventory_list)
  parent :inventory_list_index
end

crumb :inventory_list_edit do |inventory_list|
  link t('gretel.inventory_list_edit')
  parent :inventory_list_show, InventoryList.find(inventory_list.id)
end

crumb :inventory_list_use do |inventory_list|
  link t('gretel.inventory_list_use')
  parent :inventory_list_show, inventory_list
end

crumb :property_category_index do |inventory_list|
  link t('gretel.property_category_index')
  parent :inventory_list_show, inventory_list
end

crumb :property_new do |inventory_list|
  link t('gretel.property_new')
  parent :inventory_list_show, inventory_list
end

crumb :property_edit do |inventory_list, property|
  link t('gretel.property_edit', name: Property.find(property.id).property_name)
  parent :inventory_list_show, inventory_list
end

crumb :use_preset_index do |inventory_list|
  link t('gretel.use_preset_index'), inventory_list_use_presets_path(inventory_list)
  parent :inventory_list_show, inventory_list
end

crumb :use_preset_show do |inventory_list, preset|
  link t('gretel.use_preset_show', name: preset.preset_name)
  parent :use_preset_index, inventory_list
end

crumb :purchase_list_index do
  link t('gretel.purchase_list_index'), purchase_lists_path
  parent :root
end

crumb :purchase_list_new do
  link t('gretel.purchase_list_new')
  parent :purchase_list_index
end

crumb :purchase_list_show do |purchase_list|
  link t('gretel.purchase_list_show', name: purchase_list.purchase_list_name), purchase_list_path(purchase_list)
  parent :purchase_list_index
end

crumb :purchase_list_edit do |purchase_list|
  link t('gretel.purchase_list_edit')
  parent :purchase_list_show, PurchaseList.find(purchase_list.id)
end

crumb :purchase_new do |purchase_list|
  link t('gretel.purchase_new')
  parent :purchase_list_show, purchase_list
end

crumb :purchase_edit do |purchase_list, purchase|
  link t('gretel.purchase_edit', name: Purchase.find(purchase.id).purchase_name)
  parent :purchase_list_show, purchase_list
end

crumb :profile_show do
  link t('gretel.profile_show'), profile_path
  parent :root
end

crumb :profile_edit do
  link t('gretel.profile_edit')
  parent :profile_show
end

crumb :profile_password_reset do
  link t('gretel.profile_password_reset')
  parent :profile_show
end
