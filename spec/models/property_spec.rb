require 'rails_helper'

RSpec.describe Property, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      property = build(:property)
      expect(property).to be_valid
      expect(property.errors).to be_empty
    end
    it '持ち物名がない場合に適用される' do
      name_less_property = build(:property, property_name: '')
      expect(name_less_property).not_to be_valid
      expect(name_less_property.errors).not_to be_empty
    end
  end
end