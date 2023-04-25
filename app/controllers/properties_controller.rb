class PropertiesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :inventory_list_record_not_found
  before_action :set_inventory_list

  def new
    redirect_to inventory_list_property_categories_path(@inventory_list), danger: t('.category_less_alert') unless @inventory_list.property_categories.present?
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      redirect_to inventory_list_path(@inventory_list), success: t('.success', property_name: @property.property_name, category_name: @property.property_category.category_name)
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])
    if @property.update(property_params)
      redirect_to inventory_list_path(@inventory_list), success: t('.success', name: @property.property_name)
    else
      flash.now[:danger] = t('.fail', name: Property.find(@property.id).property_name)
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    name = @property.property_name
    @property.destroy!
    redirect_to inventory_list_path(@inventory_list), success: t('.success', name: name)
  end

  private

  def set_inventory_list
    @inventory_list = current_user.inventory_lists.find(params[:inventory_list_id])
  end

  def property_params
    params.require(:property).permit(:property_category_id, :property_name)
  end
end
