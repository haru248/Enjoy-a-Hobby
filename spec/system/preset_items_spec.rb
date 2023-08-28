require 'rails_helper'

RSpec.describe 'PresetItems', type: :system do
  describe 'プリセット用持ち物' do
    let!(:user) { create(:user) }
    let!(:preset) { create(:preset, user: user) }
    before { login(user) }
    context '持ち物追加' do
      context 'カテゴリーが一つ以上登録済' do
        let!(:category) { create(:item_category, preset: preset) }
        before do
          visit new_preset_preset_item_path(preset)
          modal_reset
        end
        context 'フォームの入力値が正常' do
          context 'amazon_url_or_product_name入力' do
            it '持ち物の作成に成功し、持ち物名がリンクになっている' do
              select category.item_category_name, from: 'preset_item_item_category_id'
              fill_in 'preset_item_preset_item_name', with: 'item_name'
              fill_in 'preset_item_amazon_url_or_product_name', with: 'ボタン電池'
              click_button '作成'
              expect(current_path).to eq preset_path(preset)
              within ".category#{category.id}" do
                expect(page).to have_link 'item_name'
                expect(page).not_to have_content 'このカテゴリーに登録された持ち物はありません'
              end
              expect(page).to have_content "item_nameを#{category.item_category_name}に追加しました"
            end
          end
          context 'amazon_url_or_product_name未入力' do
            it '持ち物の作成に成功し、持ち物名がリンクになっていない' do
              select category.item_category_name, from: 'preset_item_item_category_id'
              fill_in 'preset_item_preset_item_name', with: 'item_name'
              fill_in 'preset_item_amazon_url_or_product_name', with: ''
              click_button '作成'
              expect(current_path).to eq preset_path(preset)
              within ".category#{category.id}" do
                expect(page).to have_content 'item_name'
                expect(page).not_to have_content 'このカテゴリーに登録された持ち物はありません'
              end
              expect(page).to have_content "item_nameを#{category.item_category_name}に追加しました"
            end
          end
        end
        context '持ち物名が未入力' do
          it '持ち物の作成に失敗する' do
            select category.item_category_name, from: 'preset_item_item_category_id'
            fill_in 'preset_item_preset_item_name', with: ''
            click_button '作成'
            expect(page).to have_content '持ち物の作成に失敗しました'
            expect(page).to have_content '持ち物名を入力してください'
          end
        end
      end
      context 'カテゴリーが未登録の場合' do
        it 'プリセット詳細ページに飛ばされる' do
          visit preset_path(preset)
          expect(page).to have_content '登録されたカテゴリーがありません'
          visit new_preset_preset_item_path(preset)
          expect(current_path).to eq preset_item_categories_path(preset)
          expect(page).to have_content '持ち物の追加を行う場合、先にカテゴリーを1つ以上登録をしてください'
        end
      end
    end
    context '持ち物編集' do
      let!(:category) { create(:item_category, preset: preset) }
      let!(:another_category) { create(:item_category, preset: preset) }
      let!(:item) { create(:preset_item, item_category: category) }
      before do
        visit edit_preset_preset_item_path(preset, item)
        modal_reset
      end
      context 'フォームの入力値が正常' do
        context 'amazon_url_or_product_name入力' do
          it '持ち物の編集に成功し、持ち物名がリンクになっている' do
            select another_category.item_category_name, from: 'preset_item_item_category_id'
            fill_in 'preset_item_preset_item_name', with: 'update_item_name'
            fill_in 'preset_item_amazon_url_or_product_name', with: 'ボタン電池'
            click_button '更新'
            expect(current_path).to eq preset_path(preset)
            within ".category#{another_category.id}" do
              expect(page).to have_link 'update_item_name'
              expect(page).not_to have_content 'このカテゴリーに登録された持ち物はありません'
            end
            within ".category#{category.id}" do
              expect(page).not_to have_link 'update_item_name'
              expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
            end
            expect(page).to have_content 'update_item_nameの情報を更新しました'
          end
        end
        context 'amazon_url_or_product_name未入力' do
          it '持ち物の編集に成功し、持ち物名がリンクになっていない' do
            select another_category.item_category_name, from: 'preset_item_item_category_id'
            fill_in 'preset_item_preset_item_name', with: 'update_item_name'
            fill_in 'preset_item_amazon_url_or_product_name', with: ''
            click_button '更新'
            expect(current_path).to eq preset_path(preset)
            within ".category#{another_category.id}" do
              expect(page).to have_content 'update_item_name'
              expect(page).not_to have_content 'このカテゴリーに登録された持ち物はありません'
            end
            within ".category#{category.id}" do
              expect(page).not_to have_content 'update_item_name'
              expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
            end
            expect(page).to have_content 'update_item_nameの情報を更新しました'
          end
        end
      end
      context '持ち物名が未入力' do
        it '持ち物の編集に失敗する' do
          select another_category.item_category_name, from: 'preset_item_item_category_id'
          fill_in 'preset_item_preset_item_name', with: ''
          click_button '更新'
          expect(current_path).to eq preset_preset_item_path(preset, item)
          expect(page).to have_content "#{item.preset_item_name}の情報の更新に失敗しました"
          expect(page).to have_content '持ち物名を入力してください'
        end
      end
    end
    context '持ち物削除' do
      let!(:category) { create(:item_category, preset: preset) }
      let!(:item) { create(:preset_item, item_category: category) }
      context 'プリセット詳細ページ' do
        it '持ち物の削除に成功する' do
          visit preset_path(preset)
          modal_reset
          within ".item#{item.id}" do
            click_on '削除'
          end
          expect(page.accept_confirm).to eq "#{item.preset_item_name}を削除してよろしいですか?"
          expect(current_path).to eq preset_path(preset)
          expect(page).to have_content "#{item.preset_item_name}を削除しました"
          within ".category#{category.id}" do
            expect(page).not_to have_content item.preset_item_name
            expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
          end
        end
      end
      context '持ち物編集ページ' do
        it '持ち物の削除に成功する' do
          visit edit_preset_preset_item_path(preset, item)
          modal_reset
          click_on '削除'
          expect(page.accept_confirm).to eq "#{item.preset_item_name}を削除してよろしいですか?"
          expect(current_path).to eq preset_path(preset)
          expect(page).to have_content "#{item.preset_item_name}を削除しました"
          within ".category#{category.id}" do
            expect(page).not_to have_content item.preset_item_name
            expect(page).to have_content 'このカテゴリーに登録された持ち物はありません'
          end
        end
      end
    end
  end
end