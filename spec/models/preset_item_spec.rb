require 'rails_helper'

RSpec.describe PresetItem, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      preset_item = build(:preset_item)
      expect(preset_item).to be_valid
      expect(preset_item.errors).to be_empty
    end
    it '持ち物名がない場合に適用される' do
      name_less_preset_item = build(:preset_item, preset_item_name: '')
      expect(name_less_preset_item).not_to be_valid
      expect(name_less_preset_item.errors).not_to be_empty
    end
  end
end