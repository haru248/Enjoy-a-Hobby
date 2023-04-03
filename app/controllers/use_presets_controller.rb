class UsePresetsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :inventory_list_record_not_found
  before_action :set_inventory_list
  
  def index
    @q = current_user.presets.ransack(params[:q])
    @presets = @q.result.order(:created_at).page(params[:page])
  end

  def show
    @preset = current_user.presets.find(params[:id])
    @item_categories = @preset.item_categories.includes(:preset_items).order(:created_at)
    @property_categories = @inventory_list.property_categories.includes(:properties).order(:created_at)
  end

  def update
    @preset = current_user.presets.find(params[:id])
    @item_categories = @preset.item_categories.includes(:preset_items).order(:created_at)
    if @item_categories.present?
      begin
        ActiveRecord::Base.transaction do
          @item_categories.each do |item_category|
            property_category = @inventory_list.property_categories.find_category(item_category.item_category_name)
            property_category = @inventory_list.property_categories.create!(category_name: item_category.item_category_name) if property_category.nil?
            if item_category.preset_items.present?
              item_category.preset_items.each do |preset_item|
                property_category.properties.create!(property_name: preset_item.preset_item_name)
              end
            end
          end
        end
        redirect_to inventory_list_path(@inventory_list), notice: t('.success', preset_name: @preset.preset_name)
      rescue
        redirect_to inventory_list_use_preset_path(@inventory_list, @preset), alert: t('.missing_use_preset')
      end
    else
      redirect_to inventory_list_use_preset_path(@inventory_list, @preset), alert: t('.preset_category_less')
    end
  end

  private

  def set_inventory_list
    @inventory_list = current_user.inventory_lists.find(params[:inventory_list_id])
  end
end
