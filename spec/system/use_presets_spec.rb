require 'rails_helper'

RSpec.describe 'UsePresets', type: :system do
  describe '持ち物リストプリセット使用' do
    let!(:user) { create(:user) }
    let!(:preset) { create(:preset, user: user) }
    let!(:inventory_list) { create(:inventory_list, user: user) }
    before { login(user) }
    context 'プリセット使用' do
      context '使用するプリセットにカテゴリーが登録されている' do
        let!(:preset_category) { create(:item_category, preset: preset) }
        context '使用するプリセットと使用先の持ち物リストに同名のカテゴリーが存在する' do
          let!(:item) { create(:preset_item, item_category: preset_category) }
          let!(:property_category) { create(:property_category, category_name: preset_category.item_category_name, inventory_list: inventory_list) }
          let!(:property) { create(:property, property_category: property_category) }
          it '持ち物リストに同名のカテゴリーは追加されず、持ち物は持ち物リストのそのカテゴリーに登録される' do
            visit inventory_list_use_preset_path(inventory_list, preset)
            click_on 'このプリセットを使用する'
            expect(page.accept_confirm).to eq "#{inventory_list.inventory_list_name}に#{preset.preset_name}を適用してよろしいですか?"
            expect(current_path).to eq inventory_list_path(inventory_list)
            within ".category#{property_category.id}" do
              expect(page).to have_content property.property_name
              expect(page).to have_content item.preset_item_name
            end
          end
        end
        context '使用するプリセットと使用先の持ち物リストに同名のカテゴリーが存在しない' do
          let!(:item) { create(:preset_item, item_category: preset_category) }
          let!(:property_category) { create(:property_category, inventory_list: inventory_list) }
          let!(:property) { create(:property, property_category: property_category) }
          it '持ち物リストにカテゴリーと持ち物が登録される' do
            visit inventory_list_use_preset_path(inventory_list, preset)
            click_on 'このプリセットを使用する'
            expect(page.accept_confirm).to eq "#{inventory_list.inventory_list_name}に#{preset.preset_name}を適用してよろしいですか?"
            expect(current_path).to eq inventory_list_path(inventory_list)
            within ".category#{property_category.id}" do
              expect(page).to have_content property_category.category_name
              expect(page).to have_content property.property_name
            end
            preset_category_id = PropertyCategory.find_by(category_name: preset_category.item_category_name).id
            within ".category#{preset_category_id}" do
              expect(page).to have_content preset_category.item_category_name
              expect(page).to have_content item.preset_item_name
            end
          end
        end
        context '使用するプリセットに持ち物が登録されていない' do
          let!(:preset_category) { create(:item_category, preset: preset) }
          it '持ち物リストにカテゴリーだけ登録される' do
            visit inventory_list_use_preset_path(inventory_list, preset)
            click_on 'このプリセットを使用する'
            expect(page.accept_confirm).to eq "#{inventory_list.inventory_list_name}に#{preset.preset_name}を適用してよろしいですか?"
            expect(current_path).to eq inventory_list_path(inventory_list)
            preset_category_id = PropertyCategory.find_by(category_name: preset_category.item_category_name).id
            within ".category#{preset_category_id}" do
              expect(page).to have_content preset_category.item_category_name
              expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
            end
          end
        end
      end
      context '使用するプリセットにカテゴリーが登録されていない' do
        it 'エラーメッセージと共にプリセット内容確認ページにリダイレクトする' do
          visit inventory_list_use_preset_path(inventory_list, preset)
          click_on 'このプリセットを使用する'
          expect(page.accept_confirm).to eq "#{inventory_list.inventory_list_name}に#{preset.preset_name}を適用してよろしいですか?"
          expect(current_path).to eq inventory_list_use_preset_path(inventory_list, preset)
          expect(page).to have_content '使用しようとしたプリセットにカテゴリーが登録されていません'
        end
      end
    end
    context '使用プリセット選択' do
      context '検索機能' do
        context '存在するプリセット名を入力する' do
          it '検索したプリセットが表示される' do
            presets = create_list(:preset, 5, user: user)
            visit inventory_list_use_presets_path(inventory_list)
            preset = presets[0]
            another_preset = presets[1]
            fill_in 'q_preset_name_cont', with: preset.preset_name
            click_button '検索'
            expect(current_path).to eq inventory_list_use_presets_path(inventory_list)
            expect(page).to have_content preset.preset_name
            expect(page).not_to have_content another_preset.preset_name
          end
        end
        context '存在しないプリセット名を入力する' do
          it 'プリセットが表示されない' do
            presets = create_list(:preset, 5, user: user)
            visit inventory_list_use_presets_path(inventory_list)
            preset = presets[0]
            fill_in 'q_preset_name_cont', with: 'name_miss_preset'
            click_button '検索'
            expect(current_path).to eq inventory_list_use_presets_path(inventory_list)
            expect(page).not_to have_content preset.preset_name
            expect(page).to have_content 'プリセットがありません'
          end
        end
      end
      context 'ページネーション機能' do
        context 'プリセットが16件以上' do
          it 'ページネーションが表示され、正しく画面遷移する' do
            presets = create_list(:preset, 20, user: user)
            visit inventory_list_use_presets_path(inventory_list)
            expect(page).to have_css '.page-item'
            expect(page).not_to have_content presets[15].preset_name
            click_on '次 ›'
            expect(page).to have_content presets[15].preset_name
          end
        end
        context 'プリセットが15件以下' do
          it 'ページネーションが表示されない' do
            presets = create_list(:preset, 14, user: user)
            visit inventory_list_use_presets_path(inventory_list)
            expect(page).not_to have_css '.page-item'
          end
        end
      end
    end
  end
end