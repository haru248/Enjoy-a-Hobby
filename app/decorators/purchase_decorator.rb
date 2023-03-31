# frozen_string_literal: true

module PurchaseDecorator
  def amount
    price * quantity
  end
end
