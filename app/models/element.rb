class Element < ApplicationRecord
  belongs_to :post

  def amenity
    location_results.data["address"]["amenity"] if location_results
  end

  def city
    location_results.data["address"]["city"] if location_results
  end

  def state
    location_results.data["address"]["state"] if location_results
  end

  private

  def location_results
    Geocoder.search([latitude, longitude]).first if latitude && longitude
  end
end
