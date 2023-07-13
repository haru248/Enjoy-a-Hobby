module SchedulesHelper
  def date_display(schedule)
    if schedule.start_date.blank? && schedule.end_date.blank?
      t 'defaults.unregistered'
    elsif schedule.start_date == schedule.end_date
      l schedule.start_date, format: :long
    elsif schedule.start_date.present? && schedule.end_date.blank?
      l schedule.start_date, format: :long
    elsif schedule.start_date.blank? && schedule.end_date.present?
      l schedule.end_date, format: :long
    else
      "#{l schedule.start_date, format: :long} 〜 #{l schedule.end_date, format: :long}"
    end
  end

  def venue_display(schedule)
    if schedule.venue.present?
      schedule.venue
    else
      t 'defaults.unregistered'
    end
  end

  def live_date_display(live_time)
    if live_time.live_date.nil?
      t 'defaults.all_day'
    else
      l live_time.live_date
    end
  end

  def opening_time_display(live_time)
    if live_time.opening_time.nil?
      t 'defaults.opening_time_less'
    else
      l(live_time.opening_time).to_s + t('defaults.opening')
    end
  end

  def start_time_display(live_time)
    if live_time.start_time.nil?
      t 'defaults.start_time_less'
    else
      l(live_time.start_time).to_s + t('defaults.start')
    end
  end

  def lodging_display(schedule)
    if schedule.lodging.present?
      schedule.lodging
    else
      t 'defaults.unregistered'
    end
  end

  def inventory_list_display(schedule)
    if schedule.inventory_list_id.present?
      InventoryList.find(schedule.inventory_list_id).inventory_list_name
    else
      t 'defaults.unregistered'
    end
  end

  def purchase_list_display(schedule)
    if schedule.purchase_list_id.present?
      PurchaseList.find(schedule.purchase_list_id).purchase_list_name
    else
      t 'defaults.unregistered'
    end
  end
end