class LiveTime < ApplicationRecord
  belongs_to :schedule

  def edit?
    LiveTime.exists?(id: id)
  end
end
