require 'rails_helper'

RSpec.describe 'LiveTimes', type: :system do
  describe '開場・開演時間' do
    let!(:user) { create(:user) }
    let!(:schedule) { create(:schedule, user: user) }
    before { login(user) }
    context '開場・開演時間登録' do
      before { visit new_schedule_live_time_path(schedule) }
      context 'フォームの入力値が正常' do
        it '開場・開演時間の登録に成功する' do
          fill_in 'live_time_live_date', with: Date.new(2023, 01, 01)
          click_button '作成'
          expect(current_path).to eq schedule_path(schedule)
          within ".live_time#{schedule.live_times.find_by(live_date: Date.new(2023, 01, 01)).id}" do
            expect(page).to have_content '01/01'
          end
          expect(page).to have_content '01/01の開場・開演時間を登録しました'
        end
      end
    end
    context '開場・開演時間編集' do
      let!(:live_time) { create(:live_time, schedule: schedule) }
      before { visit edit_schedule_live_time_path(schedule, live_time) }
      context 'フォームの入力値が正常' do
        it '開場・開演時間の編集に成功する' do
          fill_in 'live_time_live_date', with: Date.new(2023, 01, 01)
          click_button '更新'
          expect(current_path).to eq schedule_path(schedule)
          within ".live_time#{live_time.id}" do
            expect(page).to have_content '01/01'
          end
          expect(page).to have_content '01/01の開場・開演時間を更新しました'
        end
      end
    end
    context '開場・開演時間削除' do
      let!(:live_time) { create(:live_time, schedule: schedule) }
      context 'スケジュール詳細' do
        it '開場・開演時間の削除に成功する' do
          visit schedule_path(schedule)
          within ".live_time#{live_time.id}" do
            click_on '削除'
          end
          expect(page.accept_confirm).to eq '開場・開演時間を削除してよろしいですか?'
          expect(current_path).to eq schedule_path(schedule)
          expect(page).to have_content '全日の開場・開演時間を削除しました'
          expect(page).to have_content '開場・開演時間未登録'
        end
      end
      context '開場・開演時間詳細' do
        it '開場・開演時間の削除に成功する' do
          visit edit_schedule_live_time_path(schedule, live_time)
          click_on '削除'
          expect(page.accept_confirm).to eq '開場・開演時間を削除してよろしいですか?'
          expect(current_path).to eq schedule_path(schedule)
          expect(page).to have_content '全日の開場・開演時間を削除しました'
          expect(page).to have_content '開場・開演時間未登録'
        end
      end
    end
    context '開場・開演時間表示' do
      it '開場・開演時間が正しく表示される' do
        all_day_and_unregistered_live_time = create(:live_time, schedule: schedule)
        registered_live_time = create(:live_time, schedule: schedule, live_date: Date.new(2023, 01, 01), opening_time: Time.new(2023, 1, 1, 0, 0, 0), start_time: Time.new(2023, 1, 1, 1, 0, 0))
        visit schedule_path(schedule)
        within ".live_time#{all_day_and_unregistered_live_time.id}" do
          expect(page).to have_content '全日'
          expect(page).to have_content '開場時間未登録'
          expect(page).to have_content '開演時間未登録'
        end
        within ".live_time#{registered_live_time.id}" do
          expect(page).to have_content '01/01'
          expect(page).to have_content '00:00開場'
          expect(page).to have_content '01:00開演'
        end
      end
    end
  end
end