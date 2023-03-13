require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  describe 'プロフィール編集' do
    let!(:user) { create(:user) }
    before { login(user) }
    context 'プロフィール編集ページ' do
      before { visit edit_profile_path }
      context 'フォームの入力値が正常' do
        it 'プロフィール編集に成功する' do
          fill_in 'user_user_name', with: 'test_user_update'
          fill_in 'user_email', with: 'update_test@test'
          click_button '更新'
          expect(current_path).to eq profile_path
          expect(page).to have_content 'test_user_update'
          expect(page).to have_content 'update_test@test'
          expect(page).to have_content 'プロフィールを変更しました'
        end
      end
      context 'ユーザーネームが未入力' do
        it 'プロフィール編集に失敗する' do
          fill_in 'user_user_name', with: ''
          fill_in 'user_email', with: 'update_test@test'
          click_button '更新'
          expect(current_path).to eq profile_path
          expect(page).to have_content 'ユーザーネームを入力してください'
          expect(page).to have_content 'プロフィールの編集に失敗しました'
        end
      end
      context 'メールアドレスが未入力' do
        it 'プロフィール編集に失敗する' do
          fill_in 'user_user_name', with: 'test_user_update'
          fill_in 'user_email', with: ''
          click_button '更新'
          expect(current_path).to eq profile_path
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content 'プロフィールの編集に失敗しました'
        end
      end
    end
    context 'パスワード変更ページ' do
      before { visit new_profile_path }
      context 'パスワード変更用メールの送信' do
        it 'パスワード変更用メールの送信がされる' do
          expect(page).to have_content user.email
          click_on '送信'
          expect(current_path).to eq mypage_path
          expect(page).to have_content 'パスワード変更用メールを送信しました'
          password_reset_mail = ActionMailer::Base.deliveries.last
          expect(password_reset_mail).not_to be nil
        end
      end
    end
  end
end
