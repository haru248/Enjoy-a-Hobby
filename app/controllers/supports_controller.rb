class SupportsController < ApplicationController
  skip_before_action :require_login

  def terms_of_servise; end

  def privacy_policy; end
end
