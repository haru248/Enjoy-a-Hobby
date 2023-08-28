module InventoryListsHelper
  def check_url_or_keyword(property)
    if property.amazon_url_or_product_name.start_with?('https://www.amazon.co')
      "#{property.amazon_url_or_product_name}"
    elsif property.amazon_url_or_product_name.start_with?('amazon.co')
      "https://www.#{property.amazon_url_or_product_name}"
    else
      "https://www.amazon.co.jp/gp/search?ie=UTF8&index=aps&keywords=#{property.amazon_url_or_product_name}"
    end
  end
end
