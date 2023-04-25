class PresetsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :preset_record_not_found

  def index
    @q = current_user.presets.ransack(params[:q])
    @presets = @q.result.order(:created_at).page(params[:page])
  end

  def new
    @preset = Preset.new
  end

  def create
    @preset = current_user.presets.new(preset_params)
    if @preset.save
      redirect_to preset_path(@preset), notice: t('.success', name: @preset.preset_name)
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  def show
    @preset = current_user.presets.find(params[:id])
    @item_categories = @preset.item_categories.includes(:preset_items).order(:created_at)
  end

  def edit
    @preset = current_user.presets.find(params[:id])
  end

  def update
    @preset = current_user.presets.find(params[:id])
    if @preset.update(preset_params)
      redirect_to preset_path(@preset), notice: t('.success', name: @preset.preset_name)
    else
      flash.now[:alert] = t('.fail')
      render :edit
    end
  end

  def destroy
    @preset = current_user.presets.find(params[:id])
    name = @preset.preset_name
    @preset.destroy!
    redirect_to presets_path, notice: t('.success', name: name)
  end

  private

  def preset_params
    params.require(:preset).permit(:preset_name)
  end
end
