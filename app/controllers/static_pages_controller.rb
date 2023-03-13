class StaticPagesController < ApplicationController
  skip_before_action :require_login
  before_action :require_mypage

  def top; end

  private
  def require_mypage
    return unless logged_in?
    redirect_to mypage_path
  end
end
