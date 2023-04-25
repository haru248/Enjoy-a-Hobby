require 'rails_helper'

RSpec.describe 'Presets', type: :system do
  describe 'プリセット' do
    let!(:user) { create(:user) }
    before { login(user) }
    context 'プリセット作成' do
      before { visit new_preset_path }
      context 'フォームの入力値が正常' do
        it 'プリセットの作成に成功する' do
          fill_in 'preset_preset_name', with: 'preset_1'
          click_button '作成'
          expect(current_path).to eq preset_path(Preset.find_by(preset_name: 'preset_1'))
          expect(page).to have_content 'preset_1'
          expect(page).to have_content 'preset_1を作成しました'
        end
      end
      context 'プリセット名が未入力' do
        it 'プリセットの作成に失敗する' do
          fill_in 'preset_preset_name', with: ''
          click_button '作成'
          expect(page).to have_content 'プリセットの作成に失敗しました'
          expect(page).to have_content 'プリセット名を入力してください'
        end
      end
    end
    context 'プリセット一覧' do
      context '検索機能' do
        context '存在するプリセット名を入力する' do
          it '検索したプリセットが表示される' do
            presets = create_list(:preset, 5, user: user)
            visit presets_path
            preset = presets[0]
            another_preset = presets[1]
            fill_in 'q_preset_name_cont', with: preset.preset_name
            click_button '検索'
            expect(current_path).to eq presets_path
            expect(page).to have_content preset.preset_name
            expect(page).not_to have_content another_preset.preset_name
          end
        end
        context '存在しないプリセット名を入力する' do
          it 'プリセットが表示されない' do
            presets = create_list(:preset, 5, user: user)
            visit presets_path
            preset = presets[0]
            fill_in 'q_preset_name_cont', with: 'name_miss_preset'
            click_button '検索'
            expect(current_path).to eq presets_path
            expect(page).not_to have_content preset.preset_name
            expect(page).to have_content 'プリセットがありません'
          end
        end
      end
      context 'ページネーション機能' do
        context 'プリセットが11件以上' do
          it 'ページネーションが表示され、正しく画面遷移する' do
            presets = create_list(:preset, 20, user: user)
            visit presets_path
            expect(page).to have_css '.page-item'
            expect(page).not_to have_content presets[10].preset_name
            click_on '次 ›'
            expect(page).to have_content presets[10].preset_name
          end
        end
        context 'プリセットが10件以下' do
          it 'ページネーションが表示されない' do
            presets = create_list(:preset, 10, user: user)
            visit presets_path
            expect(page).not_to have_css '.page-item'
          end
        end
      end
    end
    context 'プリセット名編集' do
      let!(:preset) { create(:preset, user: user) }
      before { visit edit_preset_path(preset) }
      context 'フォームの入力値が正常' do
        it 'プリセット名の編集に成功する' do
          fill_in 'preset_preset_name', with: 'update_preset'
          click_button '更新'
          expect(current_path).to eq preset_path(preset)
          expect(page).to have_content 'update_preset'
          expect(page).to have_content 'プリセット名をupdate_presetに変更しました'
        end
      end
      context 'プリセット名が未入力' do
        it 'プリセット名の編集に失敗する' do
          fill_in 'preset_preset_name', with: ''
          click_button '更新'
          expect(current_path).to eq preset_path(preset)
          expect(page).to have_content 'プリセット名の変更に失敗しました'
          expect(page).to have_content 'プリセット名を入力してください'
        end
      end
    end
    context 'プリセット削除' do
      let!(:preset) { create(:preset, user: user) }
      context 'プリセット一覧ページ' do
        it '削除をクリックするとプリセットが削除される' do
          visit presets_path
          click_on '削除'
          expect(page.accept_confirm).to eq "#{preset.preset_name}を削除してよろしいですか?"
          expect(current_path).to eq presets_path
          expect(page).to have_content "#{preset.preset_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
      context 'プリセット詳細ページ' do
        it 'プリセットの削除をクリックするとプリセットが削除される' do
          visit preset_path(preset)
          click_on 'プリセット削除'
          expect(page.accept_confirm).to eq "#{preset.preset_name}を削除してよろしいですか?"
          expect(current_path).to eq presets_path
          expect(page).to have_content "#{preset.preset_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
    end
  end
end