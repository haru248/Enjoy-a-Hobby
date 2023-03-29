class ItemCategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :preset_record_not_found
  before_action :set_preset

  def index
    @item_categories = @preset.item_categories.all.order(:created_at)
    @item_category = @preset.item_categories.new
  end

  def create
    @item_category = @preset.item_categories.new(category_params)
    if @item_category.save
      redirect_to preset_item_categories_path(@preset), notice: t('.success', name: @item_category.item_category_name)
    else
      redirect_to preset_item_categories_path(@preset), alert: t('.fail')
    end
  end

  def update
    @item_category = @preset.item_categories.find(params[:id])
    if @item_category.update(category_params)
      redirect_to preset_item_categories_path(@preset), notice: t('.success', name: @item_category.item_category_name)
    else
      redirect_to preset_item_categories_path(@preset), alert: t('.fail', name:  ItemCategory.find(@item_category.id).item_category_name)
    end
  end

  def destroy
    @item_category = @preset.item_categories.find(params[:id])
    name = @item_category.item_category_name
    @item_category.destroy!
    redirect_to preset_item_categories_path(@preset), notice: t('.success', name: name)
  end

  private

  def set_preset
    @preset = current_user.presets.find(params[:preset_id])
  end
  
  def category_params
    params.require(:item_category).permit(:item_category_name)
  end
end
