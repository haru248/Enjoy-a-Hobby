require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      purchase = build(:purchase)
      expect(purchase).to be_valid
      expect(purchase.errors).to be_empty
    end
    it '購入品名がない場合に適用される' do
      name_less_purchase = build(:purchase, purchase_name: '')
      expect(name_less_purchase).not_to be_valid
      expect(name_less_purchase.errors).not_to be_empty
    end
    it '金額がない場合に適用される' do
      price_less_purchase = build(:purchase, price: '')
      expect(price_less_purchase).not_to be_valid
      expect(price_less_purchase.errors).not_to be_empty
    end
    it '金額が0未満の場合に適用される' do
      price_minus_purchase = build(:purchase, price: -1)
      expect(price_minus_purchase).not_to be_valid
      expect(price_minus_purchase.errors).not_to be_empty
    end
    it '個数がない場合に適用される' do
      quantity_less_purchase = build(:purchase, quantity: '')
      expect(quantity_less_purchase).not_to be_valid
      expect(quantity_less_purchase.errors).not_to be_empty
    end
    it '個数が1未満の場合に適用される' do
      quantity_0_purchase = build(:purchase, quantity: 0)
      expect(quantity_0_purchase).not_to be_valid
      expect(quantity_0_purchase.errors).not_to be_empty
    end
  end
end