require 'rails_helper'

RSpec.describe PurchaseList, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      purchase_list = build(:purchase_list)
      expect(purchase_list).to be_valid
      expect(purchase_list.errors).to be_empty
    end
    it '物販購入リスト名がない場合に適用される' do
      name_less_purchase_list = build(:purchase_list, purchase_list_name: '')
      expect(name_less_purchase_list).not_to be_valid
      expect(name_less_purchase_list.errors).not_to be_empty
    end
  end
end