module PaySimple
  class Payment < SimpleObject
    required_attributes :account_id, :amount
    # optional_attributes :is_debit, :cvv, :payment_sub_type, :purchase_order_number, 
    #   :order_id, :description, :success_receipt_options, :sendto_customer, 
    #   :sendto_other_addresses, :failure_receipts_options

  end
end