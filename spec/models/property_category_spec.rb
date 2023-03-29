require 'rails_helper'

RSpec.describe PropertyCategory, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      property_category = build(:property_category)
      expect(property_category).to be_valid
      expect(property_category.errors).to be_empty
    end
    it 'カテゴリー名がない場合に適用される' do
      name_less_property_category = build(:property_category, category_name: '')
      expect(name_less_property_category).not_to be_valid
      expect(name_less_property_category.errors).not_to be_empty
    end
    it '同一持ち物リスト内に存在するカテゴリー名の場合に適用される' do
      inventory_list = create(:inventory_list)
      property_category = create(:property_category, inventory_list: inventory_list)
      another_property_category = build(:property_category, category_name: property_category.category_name, inventory_list: inventory_list)
      expect(another_property_category).not_to be_valid
      expect(another_property_category.errors).not_to be_empty
    end
    it '別持ち物リスト内に存在し、同一持ち物リスト内には存在しないカテゴリー名の場合に適用されない' do
      property_category = create(:property_category)
      another_property_category = build(:property_category, category_name: property_category.category_name)
      expect(another_property_category).to be_valid
      expect(another_property_category.errors).to be_empty
    end
  end
end