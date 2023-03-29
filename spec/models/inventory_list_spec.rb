require 'rails_helper'

RSpec.describe InventoryList, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      inventory_list = build(:inventory_list)
      expect(inventory_list).to be_valid
      expect(inventory_list.errors).to be_empty
    end
    it '持ち物リスト名がない場合に適用される' do
      name_less_inventory_list = build(:inventory_list, inventory_list_name: '')
      expect(name_less_inventory_list).not_to be_valid
      expect(name_less_inventory_list.errors).not_to be_empty
    end
  end
end