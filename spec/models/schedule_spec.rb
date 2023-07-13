require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'のバリデーションが' do
    it 'すべてのアトリビュートに適用されない' do
      schedule = build(:schedule)
      expect(schedule).to be_valid
      expect(schedule.errors).to be_empty
    end
    it 'スケジュール名がない場合に適用される' do
      name_less_schedule = build(:schedule, schedule_name: '')
      expect(name_less_schedule).not_to be_valid
      expect(name_less_schedule.errors).not_to be_empty
    end
  end
end