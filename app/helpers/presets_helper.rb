module PresetsHelper
  def check_url_or_keyword(preset_item)
    if preset_item.amazon_url_or_product_name.start_with?('https://www.amazon.co')
      "#{preset_item.amazon_url_or_product_name}"
    elsif preset_item.amazon_url_or_product_name.start_with?('amazon.co')
      "https://www.#{preset_item.amazon_url_or_product_name}"
    else
      "https://www.amazon.co.jp/gp/search?ie=UTF8&index=aps&keywords=#{preset_item.amazon_url_or_product_name}"
    end
  end
end
