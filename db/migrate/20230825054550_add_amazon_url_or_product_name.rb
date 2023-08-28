class AddAmazonUrlOrProductName < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :amazon_url_or_product_name, :text
    add_column :preset_items, :amazon_url_or_product_name, :text
  end
end
