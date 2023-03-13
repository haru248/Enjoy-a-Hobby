require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  describe 'ログイン' do
    let!(:user) { create(:user) }
    context 'ログインページ' do
      before { visit login_path }
      context 'フォームの入力値が正常' do
        it 'ログインに成功する' do
          fill_in 'email', with: user.email
          fill_in 'password', with: 'password'
          click_button 'ログイン'
          expect(current_path).to eq mypage_path
          expect(page).to have_content 'ログインしました'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ログインに失敗する' do
          fill_in 'password', with: 'password'
          click_button 'ログイン'
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end
      context 'パスワードが未入力' do
        it 'ログインに失敗する' do
          fill_in 'email', with: user.email
          click_button 'ログイン'
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end
      context 'メールアドレスとパスワードの組み合わせが正しくない' do
        it 'ログインに失敗する' do
          fill_in 'email', with: user.email
          fill_in 'password', with: 'password_miss'
          click_button 'ログイン'
          expect(current_path).to eq login_path
          expect(page).to have_content 'ログインに失敗しました'
        end
      end
    end
  end
end
