module PropertyCategoriesHelper
  def property_category_exists?(property_category)
    PropertyCategory.exists?(id: property_category.id)
  end
end
