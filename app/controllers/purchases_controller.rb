class PurchasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :purchase_list_record_not_found
  before_action :set_purchase_list

  def new
    @purchase = @purchase_list.purchases.new
  end

  def create
    @purchase = @purchase_list.purchases.new(purchase_params)
    if @purchase.save
      redirect_to purchase_list_path(@purchase_list), notice: t('.success', name: @purchase.purchase_name)
    else
      flash.now[:alert] = t('.fail')
      render :new
    end
  end

  def edit
    @purchase = @purchase_list.purchases.find(params[:id])
  end

  def update
    @purchase = @purchase_list.purchases.find(params[:id])
    if @purchase.update(purchase_params)
      redirect_to purchase_list_path(@purchase_list), notice: t('.success', name: @purchase.purchase_name)
    else
      flash.now[:alert] = t('.fail', name: Purchase.find(@purchase.id).purchase_name)
      render :new
    end
  end

  def destroy
    @purchase = @purchase_list.purchases.find(params[:id])
    name = @purchase.purchase_name
    @purchase.destroy!
    redirect_to purchase_list_path(@purchase_list), notice: t('.success', name: name)
  end

  private

  def set_purchase_list
    @purchase_list = current_user.purchase_lists.find(params[:purchase_list_id])
  end

  def purchase_params
    params.require(:purchase).permit(:purchase_name, :price, :quantity)
  end
end
