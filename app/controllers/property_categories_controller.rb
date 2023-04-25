class PropertyCategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :inventory_list_record_not_found
  before_action :set_inventory_list

  def index
    @property_categories = @inventory_list.property_categories.all.order(:created_at)
    @property_category = @inventory_list.property_categories.new
  end

  def create
    @property_category = @inventory_list.property_categories.new(category_params)
    if @property_category.save
      redirect_to inventory_list_property_categories_path(@inventory_list), notice: t('.success', name: @property_category.category_name)
    else
      redirect_to inventory_list_property_categories_path(@inventory_list), alert: t('.fail')
    end
  end

  def update
    @property_category = @inventory_list.property_categories.find(params[:id])
    if @property_category.update(category_params)
      redirect_to inventory_list_property_categories_path(@inventory_list), notice: t('.success', name: @property_category.category_name)
    else
      redirect_to inventory_list_property_categories_path(@inventory_list), alert: t('.fail', name:  PropertyCategory.find(@property_category.id).category_name)
    end
  end

  def destroy
    @property_category = @inventory_list.property_categories.find(params[:id])
    name = @property_category.category_name
    @property_category.destroy!
    redirect_to inventory_list_property_categories_path(@inventory_list), notice: t('.success', name: name)
  end

  private

  def set_inventory_list
    @inventory_list = current_user.inventory_lists.find(params[:inventory_list_id])
  end
  
  def category_params
    params.require(:property_category).permit(:category_name)
  end
end
