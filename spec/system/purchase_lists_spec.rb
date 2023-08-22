require 'rails_helper'

RSpec.describe 'PurchaseLists', type: :system do
  describe '物販購入リスト' do
    let!(:user) { create(:user) }
    before { login(user) }
    context '物販購入リスト作成' do
      before { visit new_purchase_list_path }
      context 'フォームの入力値が正常' do
        it '物販購入リストの作成に成功する' do
          fill_in 'purchase_list_purchase_list_name', with: 'purchase_list_1'
          click_button '作成'
          expect(current_path).to eq purchase_list_path(PurchaseList.find_by(purchase_list_name: 'purchase_list_1'))
          expect(page).to have_content 'purchase_list_1'
          expect(page).to have_content 'purchase_list_1を作成しました'
        end
      end
      context '物販購入リスト名が未入力' do
        it '物販購入リストの作成に失敗する' do
          fill_in 'purchase_list_purchase_list_name', with: ''
          click_button '作成'
          expect(page).to have_content '物販購入リストの作成に失敗しました'
          expect(page).to have_content '物販購入リスト名を入力してください'
        end
      end
    end
    context '物販購入リスト一覧' do
      context '検索機能' do
        context '存在する物販購入リスト名を入力する' do
          it '検索した物販購入リストが表示される' do
            purchase_lists = create_list(:purchase_list, 5, user: user)
            visit purchase_lists_path
            purchase_list = purchase_lists[0]
            another_purchase_list = purchase_lists[1]
            fill_in 'q_purchase_list_name_cont', with: purchase_list.purchase_list_name
            click_button '検索'
            expect(current_path).to eq purchase_lists_path
            expect(page).to have_content purchase_list.purchase_list_name
            expect(page).not_to have_content another_purchase_list.purchase_list_name
          end
        end
        context '存在しない物販購入リスト名を入力する' do
          it '物販購入リストが表示されない' do
            purchase_lists = create_list(:purchase_list, 5, user: user)
            visit purchase_lists_path
            purchase_list = purchase_lists[0]
            fill_in 'q_purchase_list_name_cont', with: 'name_miss_purchase_list'
            click_button '検索'
            expect(current_path).to eq purchase_lists_path
            expect(page).not_to have_content purchase_list.purchase_list_name
            expect(page).to have_content '物販購入リストがありません'
          end
        end
      end
      context 'ページネーション機能' do
        context '物販購入リストが11件以上' do
          it 'ページネーションが表示され、正しく画面遷移する' do
            purchase_lists = create_list(:purchase_list, 20, user: user)
            visit purchase_lists_path
            expect(page).to have_css '.page-item'
            expect(page).not_to have_content purchase_lists[10].purchase_list_name
            click_on '次 ›'
            expect(page).to have_content purchase_lists[10].purchase_list_name
          end
        end
        context '物販購入リストが10件以下' do
          it 'ページネーションが表示されない' do
            purchase_lists = create_list(:purchase_list, 10, user: user)
            visit purchase_lists_path
            expect(page).not_to have_css '.page-item'
          end
        end
      end
    end
    context '物販購入リスト名編集' do
      let!(:purchase_list) { create(:purchase_list, user: user) }
      before { visit edit_purchase_list_path(purchase_list) }
      context 'フォームの入力値が正常' do
        it '物販購入リスト名の編集に成功する' do
          fill_in 'purchase_list_purchase_list_name', with: 'update_purchase_list'
          click_button '更新'
          expect(current_path).to eq purchase_list_path(purchase_list)
          expect(page).to have_content 'update_purchase_list'
          expect(page).to have_content '物販購入リスト名をupdate_purchase_listに変更しました'
        end
      end
      context '物販購入リスト名が未入力' do
        it '物販購入リスト名の編集に失敗する' do
          fill_in 'purchase_list_purchase_list_name', with: ''
          click_button '更新'
          expect(current_path).to eq purchase_list_path(purchase_list)
          expect(page).to have_content '物販購入リスト名の変更に失敗しました'
          expect(page).to have_content '物販購入リスト名を入力してください'
        end
      end
    end
    context '物販購入リスト削除' do
      let!(:purchase_list) { create(:purchase_list, user: user) }
      context '物販購入リスト一覧ページ' do
        it '削除をクリックすると物販購入リストが削除される' do
          visit purchase_lists_path
          click_on '削除'
          expect(page.accept_confirm).to eq "#{purchase_list.purchase_list_name}を削除してよろしいですか?"
          expect(current_path).to eq purchase_lists_path
          expect(page).to have_content "#{purchase_list.purchase_list_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
      context '物販購入リスト詳細ページ' do
        it '物販購入リストの削除をクリックすると物販購入リストが削除される' do
          visit purchase_list_path(purchase_list)
          modal_reset
          click_on '物販購入リスト削除'
          expect(page.accept_confirm).to eq "#{purchase_list.purchase_list_name}を削除してよろしいですか?"
          expect(current_path).to eq purchase_lists_path
          expect(page).to have_content "#{purchase_list.purchase_list_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
    end
    context '物販購入リスト詳細' do
      context '合計金額表示' do
        let!(:purchase_list) { create(:purchase_list, user: user) }
        let!(:purchase) { create(:purchase, purchase_list: purchase_list) }
        let!(:another_purchase) { create(:purchase, purchase_list: purchase_list) }
        it '購入品が一つ以上登録されている場合に合計金額が表示される' do
          visit purchase_list_path(purchase_list)
          expect(page).to have_content purchase.purchase_name
          expect(page).to have_content another_purchase.purchase_name
          result = (purchase.price * purchase.quantity) + (another_purchase.price * another_purchase.quantity)
          expect(page).to have_content result.to_s(:delimited) + '円'
        end
      end
    end
  end
end