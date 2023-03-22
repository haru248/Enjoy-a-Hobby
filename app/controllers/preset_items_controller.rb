class PresetItemsController < ApplicationController
  before_action :set_preset
  rescue_from ActiveRecord::RecordNotFound, with: :preset_record_not_found

  def new
    redirect_to preset_item_categories_path(@preset), alert: t('.category_less_alert') unless @preset.item_categories.present?
    @preset_item = PresetItem.new
  end

  def create
    @preset_item = PresetItem.new(item_params)
    if @preset_item.save
      redirect_to preset_path(@preset), notice: t('.success', item_name: @preset_item.preset_item_name, category_name: @preset_item.item_category.item_category_name)
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  def edit
    @preset_item = PresetItem.find(params[:id])
  end

  def update
    @preset_item = PresetItem.find(params[:id])
    if @preset_item.update(item_params)
      redirect_to preset_path(@preset), notice: t('.success', name: @preset_item.preset_item_name)
    else
      flash.now[:alert] = t('.fail', name: PresetItem.find(@preset_item.id).preset_item_name)
      render :edit
    end
  end

  def destroy
    @preset_item = PresetItem.find(params[:id])
    name = @preset_item.preset_item_name
    @preset_item.destroy!
    redirect_to preset_path(@preset), notice: t('.success', name: name)
  end

  private

  def set_preset
    @preset = current_user.presets.find(params[:preset_id])
  end

  def item_params
    params.require(:preset_item).permit(:item_category_id, :preset_item_name)
  end
end
