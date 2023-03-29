module PropertiesHelper
  def property_exists?(property)
    Property.exists?(id: property.id)
  end
end
