module PaySimple
  class Address < SimpleObject
    required_attributes :street_address1, :city, :state_code, :zip_code
    optional_attributes :street_address2, :country
  end
end