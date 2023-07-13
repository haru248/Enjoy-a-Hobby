class SchedulesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :schedule_record_not_found

  def index
    @q = current_user.schedules.ransack(params[:q])
    @schedules = @q.result.order(:created_at).page(params[:page])
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)
    if @schedule.save
      redirect_to schedule_path(@schedule), success: t('.success', name: @schedule.schedule_name)
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def show
    @schedule = current_user.schedules.find(params[:id])
    @live_times = @schedule.live_times.all.order(:created_at)
  end

  def edit
    @schedule = current_user.schedules.find(params[:id])
  end

  def update
    @schedule = current_user.schedules.find(params[:id])
    if @schedule.update(schedule_params)
      redirect_to schedule_path(@schedule), success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  def destroy
    @schedule = current_user.schedules.find(params[:id])
    name = @schedule.schedule_name
    @schedule.destroy!
    redirect_to schedules_path, success: t('.success', name: name)
  end

  private

  def schedule_params
    params.require(:schedule).permit(:schedule_name, :start_date, :end_date, :venue, :lodging, :memo, :inventory_list_id, :purchase_list_id)
  end
end
