require 'spec_helper'
describe PaySimple::Client do 
  it "can create a customer" do
    customer = PaySimple::Customer.new
    customer.first_name = "Test"
    customer.last_name = "Customer"
    customer.shipping_same_as_billing = true
    customer.billing_address = PaySimple::Address.new
    customer.billing_address.street_address1 = "123 Fake Street"
    customer.billing_address.city = "Madison"
    customer.billing_address.state_code = "WI"

    client = PaySimple::Client.new
    client.create(customer)
  end

  it "parses response data to json" do 
    client = PaySimple::Client.new
    error_response = double('reponsee', body: 
      "{\"Meta\":{\"Errors\":{\"ErrorCode\":\"UnexpectedError\",\"ErrorMessages\":[{\"Field\":null,\"Message\":\"Route 'customer.json' does not exist\"}],\"TraceCode\":null},\"HttpStatus\":\"BadRequest\",\"HttpStatusCode\":400,\"PagingDetails\":null},\"Response\":null}"
    )
    client.parse_response(error_response)
    expect(client.error?).to be_true
  end
end