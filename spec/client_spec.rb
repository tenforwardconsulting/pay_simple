require 'spec_helper'
PaySimple.api_key = "asdf"
PaySimple.api_user = "TestUser"
describe PaySimple::Client do 
  let(:failure_response) {
    double('reponsee', body: 
      "{\"Meta\":{\"Errors\":{\"ErrorCode\":\"UnexpectedError\",\"ErrorMessages\":[{\"Field\":null,\"Message\":\"Route 'customer.json' does not exist\"}],\"TraceCode\":null},\"HttpStatus\":\"BadRequest\",\"HttpStatusCode\":400,\"PagingDetails\":null},\"Response\":null}"
    )
  }

  let(:success_response) {
    double('reponsee', body: 
       "{\"Meta\":{\"Errors\":null,\"HttpStatus\":\"Created\",\"HttpStatusCode\":201,\"PagingDetails\":null},\"Response\":{\"MiddleName\":null,\"AltEmail\":null,\"AltPhone\":null,\"MobilePhone\":null,\"Fax\":null,\"Website\":null,\"BillingAddress\":{\"StreetAddress1\":\"1020 N/ Tyndall Avenue\",\"StreetAddress2\":\"Unit #ZZZ\",\"City\":\"Tucson\",\"StateCode\":\"AZ\",\"ZipCode\":\"95719\",\"Country\":null},\"ShippingSameAsBilling\":true,\"ShippingAddress\":{\"StreetAddress1\":\"1020 N/ Tyndall Avenue\",\"StreetAddress2\":\"Unit #ZZZ\",\"City\":\"Tucson\",\"StateCode\":\"AZ\",\"ZipCode\":\"95719\",\"Country\":null},\"Company\":null,\"Notes\":null,\"CustomerAccount\":null,\"FirstName\":\"Test\",\"LastName\":\"Customer\",\"Email\":\"test@example.com\",\"Phone\":\"1234567890\",\"Id\":123456,\"LastModified\":\"2014-05-28T21:50:04.200377Z\",\"CreatedOn\":\"2014-05-28T21:50:04.200377Z\"}}"
    ) 
  }

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
    expect(PaySimple::Client).to receive(:post).with("/v4/customer", kind_of(Hash)).and_return success_response
    c = client.create(customer)
  end

  context "Parsing response data" do
    let(:client) {client = PaySimple::Client.new}
    before do 
      client.parse_response(failure_response)
    end  

    it "parses response data to json" do 
      expect(client.error?).to be_true
    end

    it "parses error messages" do 
      expect(client.error_messages).to eq "UnexpectedError: Route 'customer.json' does not exist"
    end
  end

  it "returns a hydrated object" do 
    client = PaySimple::Client.new
    customer = PaySimple::Customer.new
    expect(PaySimple::Client).to receive(:post).and_return success_response
    c = client.create(customer)
    expect(customer.email).to eq "test@example.com"
  end

  it "posts to the correct url for objects in a module" do 
    ach = PaySimple::Account::Ach.new

    client = PaySimple::Client.new
    expect(PaySimple::Client).to receive(:post).with("/v4/account/ach", kind_of(Hash)).and_return failure_response
    expect{client.create(ach)}.to raise_error
  end
  
end