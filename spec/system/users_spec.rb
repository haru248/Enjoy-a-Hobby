require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザー新規登録' do
    context 'ユーザー登録ページ' do
      before { visit new_user_path }
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規登録に成功する' do
          fill_in 'user_user_name', with: 'test_user'
          fill_in 'user_email', with: 'test@test'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button '登録'
          expect(current_path).to eq login_path
          expect(page).to have_content 'ユーザー登録が完了しました'
        end
      end
      context 'ユーザーネームが未入力' do
        it 'ユーザーの新規登録に失敗する' do
          fill_in 'user_email', with: 'test@test'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'ユーザーネームを入力してください'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規登録に失敗する' do
          fill_in 'user_user_name', with: 'test_user'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'メールアドレスを入力してください'
        end
      end
      context '登録済にメールアドレスが入力されている' do
        let!(:user) { create(:user, email: 'test@test') }
        it 'ユーザーの新規登録に失敗する' do
          fill_in 'user_user_name', with: 'test_user'
          fill_in 'user_email', with: 'test@test'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button '登録'
          expect(current_path).to eq users_path
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'メールアドレスはすでに存在します'
        end
      end
      context 'ユーザー登録後' do
        it 'デフォルトのプリセットが作成されている' do
          fill_in 'user_user_name', with: 'test_user'
          fill_in 'user_email', with: 'test@test'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'
          click_button '登録'
          fill_in 'email', with: 'test@test'
          fill_in 'password', with: 'password'
          click_button 'ログイン'
          visit presets_path
          expect(page).to have_content '日用品(デフォルト)'
          expect(page).to have_content '衣類(デフォルト)'
          expect(page).to have_content 'ライブ関係(デフォルト)'
          expect(page).to have_content '貴重品(デフォルト)'
          within ".preset#{Preset.find_by(preset_name: '日用品(デフォルト)').id}" do
            click_on '詳細'
          end
          expect(page).to have_content '日用品'
          expect(page).to have_content '充電器'
          expect(page).to have_content 'モバイルバッテリー'
          expect(page).to have_content 'ハンカチ'
          expect(page).to have_content 'ティッシュ'
          expect(page).to have_content '常備薬'
          expect(page).to have_content '雨具'
          visit presets_path
          within ".preset#{Preset.find_by(preset_name: '衣類(デフォルト)').id}" do
            click_on '詳細'
          end
          expect(page).to have_content '衣類'
          expect(page).to have_content '着替え'
          expect(page).to have_content 'タオル'
          expect(page).to have_content '防寒具'
          visit presets_path
          within ".preset#{Preset.find_by(preset_name: 'ライブ関係(デフォルト)').id}" do
            click_on '詳細'
          end
          expect(page).to have_content 'ライブ関係'
          expect(page).to have_content 'チケット'
          expect(page).to have_content 'ペンライト'
          expect(page).to have_content '電池'
          expect(page).to have_content 'ライブTシャツ'
          expect(page).to have_content 'ライブタオル'
          visit presets_path
          within ".preset#{Preset.find_by(preset_name: '貴重品(デフォルト)').id}" do
            click_on '詳細'
          end
          expect(page).to have_content '貴重品'
          expect(page).to have_content '財布'
          expect(page).to have_content '身分証明'
          expect(page).to have_content 'ICカード'
          expect(page).to have_content 'スマホ'
        end
      end
    end
  end
end
