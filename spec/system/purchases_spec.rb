require 'rails_helper'

RSpec.describe 'Purchases', type: :system do
  describe '物販購入リスト用購入品' do
    let!(:user) { create(:user) }
    let!(:purchase_list) { create(:purchase_list, user: user) }
    before { login(user) }
    context '購入品追加' do
      before { visit new_purchase_list_purchase_path(purchase_list) }
      context 'フォームの入力値が正常' do
        it '購入品の作成に成功する' do
          fill_in 'purchase_purchase_name', with: 'purchase_1'
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: 5
          click_button '作成'
          expect(current_path).to eq purchase_list_path(purchase_list)
          within ".purchase#{Purchase.find_by(purchase_name: 'purchase_1').id}" do
            expect(page).to have_content 'purchase_1'
            expect(page).to have_content "1,000円"
            expect(page).to have_content '5個'
            expect(page).to have_content '5,000円'
          end
          expect(page).to have_content 'purchase_1を追加しました'
        end
      end
      context '購入品名が未入力' do
        it '購入品の作成に失敗する' do
          fill_in 'purchase_purchase_name', with: ''
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: 5
          click_button '作成'
          expect(current_path).to eq purchase_list_purchases_path(purchase_list)
          expect(page).to have_content '購入品の作成に失敗しました'
          expect(page).to have_content '購入品名を入力してください'
        end
      end
      context '値段が未入力' do
        it '購入品の作成に失敗する' do
          fill_in 'purchase_purchase_name', with: 'purchase_1'
          fill_in 'purchase_price', with: ''
          fill_in 'purchase_quantity', with: 5
          click_button '作成'
          expect(current_path).to eq purchase_list_purchases_path(purchase_list)
          expect(page).to have_content '購入品の作成に失敗しました'
          expect(page).to have_content '値段を入力してください'
          expect(page).to have_content '値段は数値で入力してください'
        end
      end
      context '値段が0未満' do
        it '購入品の作成に失敗する' do
          fill_in 'purchase_purchase_name', with: 'purchase_1'
          fill_in 'purchase_price', with: -1
          fill_in 'purchase_quantity', with: 5
          click_button '作成'
          expect(current_path).not_to eq purchase_list_path(purchase_list)
        end
      end
      context '個数が未入力' do
        it '購入品の作成に失敗する' do
          fill_in 'purchase_purchase_name', with: 'purchase_1'
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: ''
          click_button '作成'
          expect(current_path).to eq purchase_list_purchases_path(purchase_list)
          expect(page).to have_content '購入品の作成に失敗しました'
          expect(page).to have_content '個数を入力してください'
          expect(page).to have_content '個数は数値で入力してください'
        end
      end
      context '個数が1未満' do
        it '購入品の作成に失敗する' do
          fill_in 'purchase_purchase_name', with: 'purchase_1'
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: 0
          click_button '作成'
          expect(current_path).not_to eq purchase_list_path(purchase_list)
        end
      end
    end
    context '購入品編集' do
      let!(:purchase) { create(:purchase, purchase_list: purchase_list) }
      before { visit edit_purchase_list_purchase_path(purchase_list, purchase) }
      context 'フォームの入力値が正常' do
        it '購入品の編集に成功する' do
          fill_in 'purchase_purchase_name', with: 'update_purchase'
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: 5
          click_button '更新'
          expect(current_path).to eq purchase_list_path(purchase_list)
          within ".purchase#{purchase.id}" do
            expect(page).to have_content 'update_purchase'
            expect(page).to have_content "1,000円"
            expect(page).to have_content '5個'
            expect(page).to have_content '5,000円'
          end
          expect(page).to have_content 'update_purchaseの情報を更新しました'
        end
      end
      context '購入品名が未入力' do
        it '購入品の編集に失敗する' do
          fill_in 'purchase_purchase_name', with: ''
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: 5
          click_button '更新'
          expect(current_path).to eq purchase_list_purchase_path(purchase_list, purchase)
          expect(page).to have_content "#{purchase.purchase_name}の情報の更新に失敗しました"
          expect(page).to have_content '購入品名を入力してください'
        end
      end
      context '値段が未入力' do
        it '購入品の編集に失敗する' do
          fill_in 'purchase_purchase_name', with: 'update_purchase'
          fill_in 'purchase_price', with: ''
          fill_in 'purchase_quantity', with: 5
          click_button '更新'
          expect(current_path).to eq purchase_list_purchase_path(purchase_list, purchase)
          expect(page).to have_content "#{purchase.purchase_name}の情報の更新に失敗しました"
          expect(page).to have_content '値段を入力してください'
          expect(page).to have_content '値段は数値で入力してください'
        end
      end
      context '値段が0未満' do
        it '購入品の編集に失敗する' do
          fill_in 'purchase_purchase_name', with: 'update_purchase'
          fill_in 'purchase_price', with: -1
          fill_in 'purchase_quantity', with: 5
          click_button '更新'
          expect(current_path).not_to eq purchase_list_path(purchase_list)
        end
      end
      context '個数が未入力' do
        it '購入品の編集に失敗する' do
          fill_in 'purchase_purchase_name', with: 'update_purchase'
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: ''
          click_button '更新'
          expect(current_path).to eq purchase_list_purchase_path(purchase_list, purchase)
          expect(page).to have_content "#{purchase.purchase_name}の情報の更新に失敗しました"
          expect(page).to have_content '個数を入力してください'
          expect(page).to have_content '個数は数値で入力してください'
        end
      end
      context '個数が1未満' do
        it '購入品の編集に失敗する' do
          fill_in 'purchase_purchase_name', with: 'update_purchase'
          fill_in 'purchase_price', with: 1000
          fill_in 'purchase_quantity', with: 0
          click_button '更新'
          expect(current_path).not_to eq purchase_list_path(purchase_list)
        end
      end
    end
    context '購入品削除' do
      let!(:purchase) { create(:purchase, purchase_list: purchase_list) }
      context '物販購入リスト詳細ページ' do
        it '購入品の削除に成功する' do
          visit purchase_list_path(purchase_list)
          modal_reset
          within ".purchase#{purchase.id}" do
            click_on '削除'
          end
          expect(page.accept_confirm).to eq "#{purchase.purchase_name}を削除してよろしいですか?"
          expect(current_path).to eq purchase_list_path(purchase_list)
          expect(page).to have_content "#{purchase.purchase_name}を削除しました"
          expect(page).to have_content '購入品が登録されていません'
        end
      end
      context '購入品編集ページ' do
        it '購入品の削除に成功する' do
          visit edit_purchase_list_purchase_path(purchase_list, purchase)
          click_on '削除'
          expect(page.accept_confirm).to eq "#{purchase.purchase_name}を削除してよろしいですか?"
          expect(current_path).to eq purchase_list_path(purchase_list)
          expect(page).to have_content "#{purchase.purchase_name}を削除しました"
          expect(page).to have_content '購入品が登録されていません'
        end
      end
    end
  end
end