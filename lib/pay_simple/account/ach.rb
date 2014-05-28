module PaySimple
  module Account
    class Ach < ::PaySimple::SimpleObject
      required_attributes :customer_id, :routing_number, :account_number, :bank_name, :is_checking_account, :is_default
    end
  end
end