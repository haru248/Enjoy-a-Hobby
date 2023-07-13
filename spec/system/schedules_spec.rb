require 'rails_helper'

RSpec.describe 'Schedules', type: :system do
  describe 'スケジュール' do
    let!(:user) { create(:user) }
    before { login(user) }
    context 'スケジュール作成' do
      before { visit new_schedule_path }
      context 'フォームの入力値が正常' do
        it 'スケジュールの作成に成功する' do
          fill_in 'schedule_schedule_name', with: 'schedule_1'
          click_button '作成'
          expect(current_path).to eq schedule_path(Schedule.find_by(schedule_name: 'schedule_1'))
          expect(page).to have_content 'schedule_1'
          expect(page).to have_content 'schedule_1を作成しました'
        end
      end
      context 'スケジュール名が未入力' do
        it 'スケジュールの作成に失敗する' do
          fill_in 'schedule_schedule_name', with: ''
          click_button '作成'
          expect(current_path).to eq schedules_path
          expect(page).to have_content 'スケジュールの作成に失敗しました'
          expect(page).to have_content 'スケジュール名を入力してください'
        end
      end
    end
    context 'スケジュール一覧' do
      context '検索機能' do
        context '存在するスケジュール名を入力する' do
          it '検索したスケジュールが表示される' do
            schedules = create_list(:schedule, 5, user: user)
            visit schedules_path
            schedule = schedules[0]
            another_schedule = schedules[1]
            fill_in 'q_schedule_name_cont', with: schedule.schedule_name
            click_button '検索'
            expect(current_path).to eq schedules_path
            expect(page).to have_content schedule.schedule_name
            expect(page).not_to have_content another_schedule.schedule_name
          end
        end
        context '存在しないスケジュール名を入力する' do
          it 'スケジュールが表示されない' do
            schedules = create_list(:schedule, 5, user: user)
            visit schedules_path
            schedule = schedules[0]
            fill_in 'q_schedule_name_cont', with: 'name_miss_schedule'
            click_button '検索'
            expect(current_path).to eq schedules_path
            expect(page).not_to have_content schedule.schedule_name
            expect(page).to have_content 'スケジュールがありません'
          end
        end
      end
      context 'ページネーション機能' do
        context 'プリセットが11件以上' do
          it 'ページネーションが表示され、正しく画面遷移する' do
            schedules = create_list(:schedule, 20, user: user)
            visit schedules_path
            expect(page).to have_css '.page-item'
            expect(page).not_to have_content schedules[10].schedule_name
            click_on '次 ›'
            expect(page).to have_content schedules[10].schedule_name
          end
        end
        context 'プリセットが10件以下' do
          it 'ページネーションが表示されない' do
            schedules = create_list(:schedule, 10, user: user)
            visit schedules_path
            expect(page).not_to have_css '.page-item'
          end
        end
      end
    end
    context 'スケジュール詳細' do
      context '日程の表示' do
        it '日程が正しく表示される' do
          unregistered_schedule = create(:schedule, user: user)
          only_start_date_schedule = create(:schedule, user: user, start_date: Date.new(2023, 01, 01))
          only_end_date_schedule = create(:schedule, user: user, end_date: Date.new(2023, 01, 02))
          full_date_schedule = create(:schedule, user: user, start_date: Date.new(2023, 01, 03), end_date: Date.new(2023, 01, 04))
          visit schedule_path(unregistered_schedule)
          within '.schedule_date' do
            expect(page).to have_content '未登録'
          end
          visit schedule_path(only_start_date_schedule)
          within '.schedule_date' do
            expect(page).to have_content '2023/01/01'
          end
          visit schedule_path(only_end_date_schedule)
          within '.schedule_date' do
            expect(page).to have_content '2023/01/02'
          end
          visit schedule_path(full_date_schedule)
          within '.schedule_date' do
            expect(page).to have_content '2023/01/03 〜 2023/01/04'
          end
        end
      end
      context '会場の表示' do
        it '開場が正しく表示される' do
          unregistered_schedule = create(:schedule, user: user)
          registered_schedule = create(:schedule, user: user, venue: 'venue1')
          visit schedule_path(unregistered_schedule)
          within '.schedule_venue' do
            expect(page).to have_content '未登録'
          end
          visit schedule_path(registered_schedule)
          within '.schedule_venue' do
            expect(page).to have_content 'venue1'
          end
        end
      end
      context '宿泊地の表示' do
        it '宿泊地が正しく表示される' do
          unregistered_schedule = create(:schedule, user: user)
          registered_schedule = create(:schedule, user: user, lodging: 'lodging1')
          visit schedule_path(unregistered_schedule)
          within '.schedule_lodging' do
            expect(page).to have_content '未登録'
          end
          visit schedule_path(registered_schedule)
          within '.schedule_lodging' do
            expect(page).to have_content 'lodging1'
          end
        end
      end
      context 'メモの表示' do
        it 'メモの表示処理が正しく適用される' do
          unregistered_schedule = create(:schedule, user: user)
          registered_schedule = create(:schedule, user: user, memo: 'memo')
          visit schedule_path(unregistered_schedule)
          expect(page).not_to have_css '.schedule_memo'
          visit schedule_path(registered_schedule)
          within '.schedule_memo' do
            expect(page).to have_content 'memo'
          end
        end
      end
      context '使用する持ち物リストの表示' do
        let!(:inventory_list) { create(:inventory_list, user: user) }
        it '使用する持ち物リストが正しく表示される' do
          unregistered_schedule = create(:schedule, user: user)
          registered_schedule = create(:schedule, user: user, inventory_list: inventory_list)
          visit schedule_path(unregistered_schedule)
          within '.schedule_inventory_list' do
            expect(page).to have_content '未登録'
          end
          visit schedule_path(registered_schedule)
          within '.schedule_inventory_list' do
            expect(page).to have_content inventory_list.inventory_list_name
          end
        end
      end
      context '使用する物販購入リストの表示' do
        let!(:purchase_list) { create(:purchase_list, user: user) }
        it '使用する物販購入リストが正しく表示される' do
          unregistered_schedule = create(:schedule, user: user)
          registered_schedule = create(:schedule, user: user, purchase_list: purchase_list)
          visit schedule_path(unregistered_schedule)
          within '.schedule_purchase_list' do
            expect(page).to have_content '未登録'
          end
          visit schedule_path(registered_schedule)
          within '.schedule_purchase_list' do
            expect(page).to have_content purchase_list.purchase_list_name
          end
        end
      end
    end
    context 'スケジュール編集' do
      let!(:schedule) { create(:schedule, user: user) }
      before { visit edit_schedule_path(schedule) }
      context 'フォームの入力値が正常' do
        it 'スケジュールの編集に成功する' do
          fill_in 'schedule_schedule_name', with: 'update_schedule'
          click_button '更新'
          expect(current_path).to eq schedule_path(schedule)
          expect(page).to have_content 'update_schedule'
          expect(page).to have_content 'スケジュール内容を更新しました'
        end
      end
      context 'スケジュール名が未入力' do
        it 'スケジュールの編集に失敗する' do
          fill_in 'schedule_schedule_name', with: ''
          click_button '更新'
          expect(current_path).to eq schedule_path(schedule)
          expect(page).to have_content 'スケジュール内容の更新に失敗しました'
          expect(page).to have_content 'スケジュール名を入力してください'
        end
      end
    end
    context 'スケジュール削除' do
      let!(:schedule) { create(:schedule, user: user) }
      context 'スケジュール一覧ページ' do
        it '削除をクリックするとスケジュールが削除される' do
          visit schedules_path
          click_on '削除'
          expect(page.accept_confirm).to eq "#{schedule.schedule_name}を削除してよろしいですか?"
          expect(current_path).to eq schedules_path
          expect(page).to have_content "#{schedule.schedule_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
      context 'スケジュール詳細ページ' do
        it 'スケジュール削除をクリックするとスケジュールが削除される' do
          visit schedule_path(schedule)
          click_on 'スケジュール削除'
          expect(page.accept_confirm).to eq "#{schedule.schedule_name}を削除してよろしいですか?"
          expect(current_path).to eq schedules_path
          expect(page).to have_content "#{schedule.schedule_name}を削除しました"
          expect(page).not_to have_link '詳細'
        end
      end
    end
  end
end