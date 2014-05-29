module PaySimple
  class Customer < SimpleObject
    required_attributes :first_name, :last_name, :shipping_same_as_billing
    optional_attributes :middle_name, :email, :phone, :notes, :company, :customer_account

    has_one :billing_address, class_name: "Address", serialize: true
    has_one :shipping_address, class_name: "Address", serialize: true

    has_one :defaultach, class_name: "Account::Ach"
  end
end