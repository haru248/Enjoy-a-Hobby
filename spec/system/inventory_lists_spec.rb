require 'rails_helper'

RSpec.describe 'InventoryLists', type: :system do
  describe '持ち物リスト' do
    let!(:user) { create(:user) }
    before { login(user) }
    context '持ち物リスト作成' do
      before { visit new_inventory_list_path }
      context 'フォームの入力値が正常' do
        it '持ち物リストの作成に成功する' do
          fill_in 'inventory_list_inventory_list_name', with: 'inventory_list_1'
          click_button '作成'
          expect(current_path).to eq inventory_list_path(InventoryList.find_by(inventory_list_name: 'inventory_list_1'))
          expect(page).to have_content 'inventory_list_1'
          expect(page).to have_content 'inventory_list_1を作成しました'
        end
      end
      context '持ち物リスト名が未入力' do
        it '持ち物リストの作成に失敗する' do
          fill_in 'inventory_list_inventory_list_name', with: ''
          click_button '作成'
          expect(page).to have_content '持ち物リストの作成に失敗しました'
          expect(page).to have_content '持ち物リスト名を入力してください'
        end
      end
    end
    context '持ち物リスト一覧' do
      context '検索機能' do
        context '存在する持ち物リスト名を入力する' do
          it '検索した持ち物リストが表示される' do
            inventory_lists = create_list(:inventory_list, 5, user: user)
            visit inventory_lists_path
            inventory_list = inventory_lists[0]
            another_inventory_list = inventory_lists[1]
            fill_in 'q_inventory_list_name_cont', with: inventory_list.inventory_list_name
            click_button '検索'
            expect(current_path).to eq inventory_lists_path
            expect(page).to have_content inventory_list.inventory_list_name
            expect(page).not_to have_content another_inventory_list.inventory_list_name
          end
        end
        context '存在しない持ち物リスト名を入力する' do
          it '持ち物リストが表示されない' do
            inventory_lists = create_list(:inventory_list, 5, user: user)
            visit inventory_lists_path
            inventory_list = inventory_lists[0]
            fill_in 'q_inventory_list_name_cont', with: 'name_miss_inventory_list'
            click_button '検索'
            expect(current_path).to eq inventory_lists_path
            expect(page).not_to have_content inventory_list.inventory_list_name
            expect(page).to have_content '持ち物リストがありません'
          end
        end
      end
      context 'ページネーション機能' do
        context '持ち物リストが11件以上' do
          it 'ページネーションが表示され、正しく画面遷移する' do
            inventory_lists = create_list(:inventory_list, 20, user: user)
            visit inventory_lists_path
            expect(page).to have_css '.page-item'
            expect(page).not_to have_content inventory_lists[10].inventory_list_name
            click_on '次 ›'
            expect(page).to have_content inventory_lists[10].inventory_list_name
          end
        end
        context '持ち物リストが10件以下' do
          it 'ページネーションが表示されない' do
            inventory_lists = create_list(:inventory_list, 10, user: user)
            visit inventory_lists_path
            expect(page).not_to have_css '.page-item'
          end
        end
      end
    end
    context '持ち物リスト名編集' do
      let!(:inventory_list) { create(:inventory_list, user: user) }
      before { visit edit_inventory_list_path(inventory_list) }
      context 'フォームの入力値が正常' do
        it '持ち物リスト名の編集に成功する' do
          fill_in 'inventory_list_inventory_list_name', with: 'update_inventory_list'
          click_button '更新'
          expect(current_path).to eq inventory_list_path(inventory_list)
          expect(page).to have_content 'update_inventory_list'
          expect(page).to have_content '持ち物リスト名をupdate_inventory_listに変更しました'
        end
      end
      context '持ち物リスト名が未入力' do
        it '持ち物リスト名の編集に失敗する' do
          fill_in 'inventory_list_inventory_list_name', with: ''
          click_button '更新'
          expect(current_path).to eq inventory_list_path(inventory_list)
          expect(page).to have_content '持ち物リスト名の変更に失敗しました'
          expect(page).to have_content '持ち物リスト名を入力してください'
        end
      end
    end
    context '持ち物リスト削除' do
      let!(:inventory_list) { create(:inventory_list, user: user) }
      context '持ち物リスト一覧ページ' do
        it '削除をクリックすると持ち物リストが削除される' do
          visit inventory_lists_path
          click_on '削除'
          expect(page.accept_confirm).to eq "#{inventory_list.inventory_list_name}を削除してよろしいですか?"
          expect(current_path).to eq inventory_lists_path
          expect(page).to have_content "#{inventory_list.inventory_list_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
      context '持ち物リスト詳細ページ' do
        it '持ち物リスト削除をクリックすると持ち物リストが削除される' do
          visit inventory_list_path(inventory_list)
          modal_reset
          click_on '持ち物リスト削除'
          expect(page.accept_confirm).to eq "#{inventory_list.inventory_list_name}を削除してよろしいですか?"
          expect(current_path).to eq inventory_lists_path
          expect(page).to have_content "#{inventory_list.inventory_list_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
    end
    context '持ち物リスト使用' do
      let!(:inventory_list) { create(:inventory_list, user: user) }
      let!(:property_category) { create(:property_category, inventory_list: inventory_list) }
      let!(:property) { create(:property, property_category: property_category) }
      let!(:another_property) { create(:property, property_category: property_category, amazon_url_or_product_name: 'ボタン電池') }
      before { visit use_inventory_list_path(inventory_list) }
      context '持ち物リスト使用ページ' do
        context '「チェックした持ち物を隠さない」が選択されている' do
          it '持ち物のチェックボタンをチェックしても持ち物が隠れない' do
            choose 'チェックした持ち物を隠さない'
            check property.property_name
            uncheck another_property.property_name
            expect(page).to have_content property.property_name
            expect(page).to have_content another_property.property_name
          end
          it '持ち物のチェックボタンをチェックした後に「チェックした持ち物を隠す」を選択すると、チェックされた持ち物が隠れる' do
            choose 'チェックした持ち物を隠さない'
            check property.property_name
            uncheck another_property.property_name
            choose 'チェックした持ち物を隠す'
            expect(page).not_to have_content property.property_name
            expect(page).to have_content another_property.property_name
          end
        end
        context '「チェックした持ち物を隠す」が選択されている' do
          it '持ち物のチェックボタンをチェックしたら持ち物が隠れる' do
            choose 'チェックした持ち物を隠す'
            check property.property_name
            uncheck another_property.property_name
            expect(page).not_to have_content property.property_name
            expect(page).to have_content another_property.property_name
          end
          it '持ち物のチェックボタンをチェックした後に「チェックした持ち物を隠さない」を選択すると、チェックされた持ち物が表示される' do
            choose 'チェックした持ち物を隠す'
            check property.property_name
            uncheck another_property.property_name
            choose 'チェックした持ち物を隠さない'
            expect(page).to have_content property.property_name
            expect(page).to have_content another_property.property_name
          end
        end
        it 'amazon_url_or_product_nameが入力されている持ち物名がリンクになっている' do
          expect(page).to have_content property.property_name
          expect(page).not_to have_link property.property_name
          expect(page).to have_link another_property.property_name
        end
      end
    end
  end
end