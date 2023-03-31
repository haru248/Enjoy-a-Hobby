class ApplicationController < ActionController::Base
  before_action :require_login
  
  private

  def not_authenticated
    redirect_to login_path
  end

  def preset_record_not_found
    redirect_to presets_path, alert: t('defaults.record_not_found')
  end

  def inventory_list_record_not_found
    redirect_to inventory_lists_path, alert: t('defaults.record_not_found')
  end

  def purchase_list_record_not_found
    redirect_to purchase_lists_path, alert: t('defaults.record_not_found')
  end
end
