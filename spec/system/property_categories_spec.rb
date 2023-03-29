require 'rails_helper'

RSpec.describe 'ProeprtyCategories', type: :system do
  describe '持ち物リスト用カテゴリー' do
    let!(:user) { create(:user) }
    let!(:inventory_list) { create(:inventory_list, user: user) }
    before { login(user) }
    context 'カテゴリー編集ページ' do
      context 'カテゴリー作成' do
        context 'フォームの入力値が正常' do
          it 'カテゴリーの作成に成功する' do
            visit inventory_list_property_categories_path(inventory_list)
            fill_in 'property_category_category_name', with: 'category_1'
            click_button '作成'
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content 'category_1を作成しました'
            visit inventory_list_path(inventory_list)
            expect(page).to have_content 'category_1'
            expect(page).not_to have_content '登録されたカテゴリーがありません'
          end
        end
        context 'カテゴリー名が未入力' do
          it 'カテゴリーの作成に失敗する' do
            visit inventory_list_property_categories_path(inventory_list)
            fill_in 'property_category_category_name', with: ''
            click_button '作成'
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content 'カテゴリーの作成に失敗しました'
            visit inventory_list_path(inventory_list)
            expect(page).to have_content '登録されたカテゴリーがありません'
          end
        end
        context '既存のカテゴリー名と同じカテゴリー名が入力' do
          let!(:category) { create(:property_category, inventory_list: inventory_list) }
          it 'カテゴリーの作成に失敗する' do
            visit inventory_list_property_categories_path(inventory_list)
            within ".category" do
              fill_in 'property_category_category_name', with: category.category_name
              click_button '作成'
            end
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content 'カテゴリーの作成に失敗しました'
          end
        end
      end
      context 'カテゴリー編集' do
        let!(:category) { create(:property_category, inventory_list: inventory_list) }
        context 'フォームの入力値が正常' do
          it 'カテゴリーの編集に成功する' do
            visit inventory_list_property_categories_path(inventory_list)
            within ".category#{category.id}" do
              fill_in 'property_category_category_name', with: 'update_category_name'
              click_button '更新'
            end
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content "カテゴリー名をupdate_category_nameに更新しました"
            visit inventory_list_path(inventory_list)
            expect(page).to have_content 'update_category_name'
            expect(page).not_to have_content '登録されたカテゴリーがありません'
          end
        end
        context 'カテゴリー名が未入力' do
          it 'カテゴリーの編集に失敗する' do
            visit inventory_list_property_categories_path(inventory_list)
            within ".category#{category.id}" do
              fill_in 'property_category_category_name', with: ''
              click_button '更新'
            end
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content "#{category.category_name}のカテゴリー名の変更に失敗しました"
          end
        end
        context '既存のカテゴリー名と同じカテゴリー名が入力' do
          let!(:another_category) { create(:property_category, inventory_list: inventory_list) }
          it 'カテゴリーの編集に失敗する' do
            visit inventory_list_property_categories_path(inventory_list)
            within ".category#{category.id}" do
              fill_in 'property_category_category_name', with: another_category.category_name
              click_button '更新'
            end
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content "#{category.category_name}のカテゴリー名の変更に失敗しました"
          end
        end
      end
      context 'カテゴリー削除' do
        let!(:category) { create(:property_category, inventory_list: inventory_list) }
        context '削除するカテゴリーの削除をクリックする' do
          it 'カテゴリーの削除に成功する' do
            visit inventory_list_property_categories_path(inventory_list)
            within ".category#{category.id}" do
              click_on '削除'
            end
            expect(page.accept_confirm).to eq "カテゴリーを削除すると、そのカテゴリーの持ち物も削除されます。#{category.category_name}を削除してよろしいですか?"
            expect(current_path).to eq inventory_list_property_categories_path(inventory_list)
            expect(page).to have_content "#{category.category_name}を削除しました"
            visit inventory_list_path(inventory_list)
            expect(page).not_to have_content category.category_name
            expect(page).to have_content '登録されたカテゴリーがありません'
          end
          context '削除するカテゴリーに持ち物が登録されている場合' do
            let!(:property) { create(:property, property_category: category) }
            it '持ち物も削除される' do
              visit inventory_list_property_categories_path(inventory_list)
              within ".category#{category.id}" do
                click_on '削除'
              end
              accept_confirm
              visit inventory_list_path(inventory_list)
              expect(page).not_to have_content property.property_name
              expect(Property.find_by(id: property.id)).to be nil
            end
          end
        end
      end
    end
  end
end