class LiveTimesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :schedule_record_not_found
  before_action :set_schedule

  def new
    @live_time = @schedule.live_times.new
  end

  def create
    @live_time = @schedule.live_times.new(live_time_params)
    if @live_time.save
      redirect_to schedule_path(@schedule), success: t('.success', date: live_date_message)
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def edit
    @live_time = @schedule.live_times.find(params[:id])
  end

  def update
    @live_time = @schedule.live_times.find(params[:id])
    if @live_time.update(live_time_params)
      redirect_to schedule_path(@schedule), success: t('.success', date: live_date_message)
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  def destroy
    @live_time = @schedule.live_times.find(params[:id])
    date = live_date_message
    @live_time.destroy!
    redirect_to schedule_path(@schedule), success: t('.success', date: date)
  end

  private

  def set_schedule
    @schedule = current_user.schedules.find(params[:schedule_id])
  end

  def live_time_params
    params.require(:live_time).permit(:live_date, :opening_time, :start_time)
  end

  def live_date_message
    if @live_time.live_date.present?
      l @live_time.live_date
    else
      t 'defaults.all_day'
    end
  end
end
