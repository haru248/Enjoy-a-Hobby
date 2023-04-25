class PurchaseListsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :purchase_list_record_not_found

  def index
    @q = current_user.purchase_lists.ransack(params[:q])
    @purchase_lists = @q.result.order(:created_at).page(params[:page])
  end

  def new
    @purchase_list = PurchaseList.new
  end

  def create
    @purchase_list = current_user.purchase_lists.new(list_params)
    if @purchase_list.save
      redirect_to purchase_list_path(@purchase_list), success: t('.success', name: @purchase_list.purchase_list_name)
    else
      flash.now[:danger] = t('.fail')
      render :new
    end
  end

  def show
    @purchase_list = current_user.purchase_lists.find(params[:id])
    @purchases = @purchase_list.purchases.all.order(:created_at)
  end

  def edit
    @purchase_list = current_user.purchase_lists.find(params[:id])
  end

  def update
    @purchase_list = current_user.purchase_lists.find(params[:id])
    if @purchase_list.update(list_params)
      redirect_to purchase_list_path(@purchase_list), success: t('.success', name: @purchase_list.purchase_list_name)
    else
      flash.now[:danger] = t('.fail')
      render :edit
    end
  end

  def destroy
    @purchase_list = current_user.purchase_lists.find(params[:id])
    name = @purchase_list.purchase_list_name
    @purchase_list.destroy!
    redirect_to purchase_lists_path, success: t('.success', name: name)
  end

  private

  def list_params
    params.require(:purchase_list).permit(:purchase_list_name)
  end
end
