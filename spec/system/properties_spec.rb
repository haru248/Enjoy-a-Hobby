require 'rails_helper'

RSpec.describe 'Properties', type: :system do
  describe '持ち物リスト用持ち物' do
    let!(:user) { create(:user) }
    let!(:inventory_list) { create(:inventory_list, user: user) }
    before { login(user) }
    context '持ち物追加' do
      context 'カテゴリーが一つ以上登録済' do
        let!(:category) { create(:property_category, inventory_list: inventory_list) }
        before { visit new_inventory_list_property_path(inventory_list) }
        context 'フォームの入力値が正常' do
          it '持ち物の作成に成功する' do
            select category.category_name, from: 'property_property_category_id'
            fill_in 'property_property_name', with: 'property_name'
            click_button '作成'
            expect(current_path).to eq inventory_list_path(inventory_list)
            within ".category#{category.id}" do
              expect(page).to have_content 'property_name'
              expect(page).not_to have_content 'このカテゴリーに登録された持ち物はありません'
            end
            expect(page).to have_content "property_nameを#{category.category_name}に追加しました"
          end
        end
        context '持ち物名が未入力' do
          it '持ち物の作成に失敗する' do
            select category.category_name, from: 'property_property_category_id'
            fill_in 'property_property_name', with: ''
            click_button '作成'
            expect(page).to have_content '持ち物の作成に失敗しました'
            expect(page).to have_content '持ち物名を入力してください'
          end
        end
      end
      context 'カテゴリーが未登録の場合' do
        it 'プリセット詳細ページに飛ばされる' do
          visit inventory_list_path(inventory_list)
          expect(page).to have_content '登録されたカテゴリーがありません'
          visit new_inventory_list_property_path(inventory_list)
          expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
          expect(page).to have_content '持ち物の追加を行う場合、先にカテゴリーを1つ以上登録をしてください'
        end
      end
    end
    context '持ち物編集' do
      let!(:category) { create(:property_category, inventory_list: inventory_list) }
      let!(:another_category) { create(:property_category, inventory_list: inventory_list) }
      let!(:property) { create(:property, property_category: category) }
      before { visit edit_inventory_list_property_path(inventory_list, property) }
      context 'フォームの入力値が正常' do
        it '持ち物の編集に成功する' do
          select another_category.category_name, from: 'property_property_category_id'
          fill_in 'property_property_name', with: 'update_property_name'
          click_button '更新'
          expect(current_path).to eq inventory_list_path(inventory_list)
          within ".category#{another_category.id}" do
            expect(page).to have_content 'update_property_name'
            expect(page).not_to have_content 'このカテゴリーに登録された持ち物はありません'
          end
          within ".category#{category.id}" do
            expect(page).not_to have_content 'update_property_name'
            expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
          end
          expect(page).to have_content 'update_property_nameの情報を更新しました'
        end
      end
      context '持ち物名が未入力' do
        it '持ち物の編集に失敗する' do
          select another_category.category_name, from: 'property_property_category_id'
          fill_in 'property_property_name', with: ''
          click_button '更新'
          expect(current_path).to eq inventory_list_property_path(inventory_list, property)
          expect(page).to have_content "#{property.property_name}の情報の更新に失敗しました"
          expect(page).to have_content '持ち物名を入力してください'
        end
      end
    end
    context '持ち物削除' do
      let!(:category) { create(:property_category, inventory_list: inventory_list) }
      let!(:property) { create(:property, property_category: category) }
      context '持ち物リスト詳細ページ' do
        it '持ち物の削除に成功する' do
          visit inventory_list_path(inventory_list)
          modal_reset
          within ".property#{property.id}" do
            click_on '削除'
          end
          expect(page.accept_confirm).to eq "#{property.property_name}を削除してよろしいですか?"
          expect(current_path).to eq inventory_list_path(inventory_list)
          expect(page).to have_content "#{property.property_name}を削除しました"
          within ".category#{category.id}" do
            expect(page).not_to have_content property.property_name
            expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
          end
        end
      end
      context '持ち物編集ページ' do
        it '持ち物の削除に成功する' do
          visit edit_inventory_list_property_path(inventory_list, property)
          click_on '削除'
          expect(page.accept_confirm).to eq "#{property.property_name}を削除してよろしいですか?"
          expect(current_path).to eq inventory_list_path(inventory_list)
          expect(page).to have_content "#{property.property_name}を削除しました"
          within ".category#{category.id}" do
            expect(page).not_to have_content property.property_name
            expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
          end
        end
      end
    end
  end
end