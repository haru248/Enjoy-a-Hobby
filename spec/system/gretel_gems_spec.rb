require 'rails_helper'

RSpec.describe 'gretel_gems', type: :system do
  describe 'パンくず' do
    context 'ログイン前' do
      context 'ユーザー登録' do
        it 'パンくずリンクが機能している' do
          visit new_user_path
          within('.breadcrumbs') do
            expect(page).to have_link 'トップページ'
            expect(page).to have_content 'ユーザー登録'
            click_on 'トップページ'
          end
          expect(current_path).to eq root_path
        end
      end
      context 'ログイン、パスワードリセットページ' do
        it 'パンくずリンクが機能している' do
          visit new_password_reset_path
          within('.breadcrumbs') do
            expect(page).to have_link 'トップページ'
            expect(page).to have_link 'ログイン'
            expect(page).to have_content 'パスワードリセット'
            click_on 'ログイン'
          end
          expect(current_path).to eq login_path
        end
      end
    end
    context 'ログイン後' do
      let!(:user) { create(:user) }
      let!(:preset) { create(:preset, user: user) }
      let!(:item_category) { create(:item_category, preset: preset) }
      let!(:item) { create(:preset_item, item_category: item_category) }
      let!(:inventory_list) { create(:inventory_list, user: user) }
      let!(:property_category) { create(:property_category, inventory_list: inventory_list) }
      let!(:property) { create(:property, property_category: property_category) }
      let!(:purchase_list) { create(:purchase_list, user: user) }
      let!(:purchase) { create(:purchase, purchase_list: purchase_list) }
      before { login(user) }
      context 'プリセット関連ページ' do
        it 'パンくずリンクが機能している' do
          visit new_preset_path
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プリセット一覧'
            expect(page).to have_content 'プリセット作成'
            click_on 'マイページ'
          end
          expect(current_path).to eq mypage_path
          visit edit_preset_path(preset)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プリセット一覧'
            expect(page).to have_link preset.preset_name
            expect(page).to have_content 'プリセット名編集'
            click_on 'プリセット一覧'
          end
          expect(current_path).to eq presets_path
          visit preset_item_categories_path(preset)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プリセット一覧'
            expect(page).to have_link preset.preset_name
            expect(page).to have_content 'カテゴリー編集'
            click_on preset.preset_name
          end
          expect(current_path).to eq preset_path(preset)
          visit new_preset_preset_item_path(preset)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プリセット一覧'
            expect(page).to have_link preset.preset_name
            expect(page).to have_content '持ち物追加'
          end
          visit edit_preset_preset_item_path(preset, item)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プリセット一覧'
            expect(page).to have_link preset.preset_name
            expect(page).to have_content "#{item.preset_item_name}編集"
          end
        end
      end
      context '持ち物リスト関係ページ' do
        it 'パンくずリンクが機能している' do
          visit new_inventory_list_path
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_content '持ち物リスト作成'
            click_on 'マイページ'
          end
          expect(current_path).to eq mypage_path
          visit edit_inventory_list_path(inventory_list)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_link inventory_list.inventory_list_name
            expect(page).to have_content 'リスト名編集'
            click_on '持ち物リスト一覧'
          end
          expect(current_path).to eq inventory_lists_path
          visit use_inventory_list_path(inventory_list)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_link inventory_list.inventory_list_name
            expect(page).to have_content 'リスト使用'
            click_on inventory_list.inventory_list_name
          end
          expect(current_path).to eq inventory_list_path(inventory_list)
          visit inventory_list_property_categories_path(inventory_list)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_link inventory_list.inventory_list_name
            expect(page).to have_content 'カテゴリー編集'
          end
          visit new_inventory_list_property_path(inventory_list)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_link inventory_list.inventory_list_name
            expect(page).to have_content '持ち物追加'
          end
          visit edit_inventory_list_property_path(inventory_list, property)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_link inventory_list.inventory_list_name
            expect(page).to have_content "#{property.property_name}編集"
          end
          visit inventory_list_use_preset_path(inventory_list, preset)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '持ち物リスト一覧'
            expect(page).to have_link inventory_list.inventory_list_name
            expect(page).to have_link '使用プリセット一覧'
            expect(page).to have_content "#{preset.preset_name}確認"
            click_on '使用プリセット一覧'
          end
          expect(current_path).to eq inventory_list_use_presets_path(inventory_list)
        end
      end
      context '物販購入リスト関係ページ' do
        it 'パンくずリンクが機能している' do
          visit new_purchase_list_path
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '物販購入リスト一覧'
            expect(page).to have_content '物販購入リスト作成'
            click_on 'マイページ'
          end
          expect(current_path).to eq mypage_path
          visit edit_purchase_list_path(purchase_list)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '物販購入リスト一覧'
            expect(page).to have_link purchase_list.purchase_list_name
            expect(page).to have_content 'リスト名編集'
            click_on '物販購入リスト一覧'
          end
          expect(current_path).to eq purchase_lists_path
          visit new_purchase_list_purchase_path(purchase_list)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '物販購入リスト一覧'
            expect(page).to have_link purchase_list.purchase_list_name
            expect(page).to have_content '購入品追加'
            click_on purchase_list.purchase_list_name
          end
          expect(current_path).to eq purchase_list_path(purchase_list)
          visit edit_purchase_list_purchase_path(purchase_list, purchase)
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link '物販購入リスト一覧'
            expect(page).to have_link purchase_list.purchase_list_name
            expect(page).to have_content "#{purchase.purchase_name}編集"
          end
        end
      end
      context 'プロフィール関係ページ' do
        it 'パンくずリンクが機能している' do
          visit edit_profile_path
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プロフィール確認'
            expect(page).to have_content '編集'
            click_on 'マイページ'
          end
          expect(current_path).to eq mypage_path
          visit password_reset_profile_path
          within('.breadcrumbs') do
            expect(page).to have_link 'マイページ'
            expect(page).to have_link 'プロフィール確認'
            expect(page).to have_content 'パスワードリセット'
            click_on 'プロフィール確認'
          end
          expect(current_path).to eq profile_path
        end
      end
    end
  end
end