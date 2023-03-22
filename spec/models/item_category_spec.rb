require 'rails_helper'

RSpec.describe ItemCategory, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      item_category = build(:item_category)
      expect(item_category).to be_valid
      expect(item_category.errors).to be_empty
    end
    it 'カテゴリー名がない場合に適用される' do
      name_less_item_category = build(:item_category, item_category_name: '')
      expect(name_less_item_category).not_to be_valid
      expect(name_less_item_category.errors).not_to be_empty
    end
    it '同一プリセット内に存在するカテゴリー名の場合に適用される' do
      preset = create(:preset)
      item_category = create(:item_category, preset: preset)
      another_item_category = build(:item_category, item_category_name: item_category.item_category_name, preset: preset)
      expect(another_item_category).not_to be_valid
      expect(another_item_category.errors).not_to be_empty
    end
    it '別プリセット内に存在し、同一プリセット内には存在しないカテゴリー名の場合に適用されない' do
      item_category = create(:item_category)
      another_item_category = build(:item_category, item_category_name: item_category.item_category_name)
      expect(item_category).to be_valid
      expect(item_category.errors).to be_empty
    end
  end
end