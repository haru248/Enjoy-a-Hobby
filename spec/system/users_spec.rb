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
    end
  end
end