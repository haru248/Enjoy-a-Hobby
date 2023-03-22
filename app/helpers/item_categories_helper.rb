module ItemCategoriesHelper
  def item_category_exists?(item_category)
    ItemCategory.exists?(id: item_category.id)
  end
end
