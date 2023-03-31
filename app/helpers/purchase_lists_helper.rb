module PurchaseListsHelper
  def sum_amount(purchases)
    result = 0
    purchases.each do |purchase|
      result += purchase.amount
    end
    result.to_s(:delimited) + t('defaults.yen')
  end
end
