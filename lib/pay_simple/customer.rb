module PaySimple
  class Customer < SimpleObject
    required_attributes :first_name, :last_name, :shipping_same_as_billing
    optional_attributes :middle_name, :email, :phone, :notes, :company, :billing_address
  end
end