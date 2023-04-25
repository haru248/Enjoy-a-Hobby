class InventoryListsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :inventory_list_record_not_found

  def index
    @q = current_user.inventory_lists.ransack(params[:q])
    @inventory_lists = @q.result.order(:created_at).page(params[:page])
  end

  def new
    @inventory_list = InventoryList.new
  end

  def create
    @inventory_list = current_user.inventory_lists.new(list_params)
    if @inventory_list.save
      redirect_to inventory_list_path(@inventory_list), success: t('.success', name: @inventory_list.inventory_list_name)
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def show
    @inventory_list = current_user.inventory_lists.find(params[:id])
    @property_categories = @inventory_list.property_categories.includes(:properties).order(:created_at)
  end

  def edit
    @inventory_list = current_user.inventory_lists.find(params[:id])
  end

  def update
    @inventory_list = current_user.inventory_lists.find(params[:id])
    if @inventory_list.update(list_params)
      redirect_to inventory_list_path(@inventory_list), success: t('.success', name: @inventory_list.inventory_list_name)
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  def destroy
    @inventory_list = current_user.inventory_lists.find(params[:id])
    name = @inventory_list.inventory_list_name
    @inventory_list.destroy!
    redirect_to inventory_lists_path, success: t('.success', name: name)
  end

  def use
    @inventory_list = current_user.inventory_lists.find(params[:id])
    @property_categories = @inventory_list.property_categories.includes(:properties).order(:created_at)
  end

  private

  def list_params
    params.require(:inventory_list).permit(:inventory_list_name)
  end
end
