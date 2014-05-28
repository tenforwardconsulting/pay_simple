# PaySimple

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'pay_simple'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pay_simple

## Usage

Set up your API Key and username: 

    PaySimple.api_key = "VeryLongSharedSecretStringGoesHere"
    PaySimple.api_user = "ApiUser1234"

Creat a customer

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

## Contributing

1. Fork it ( http://github.com/<my-github-username>/pay_simple/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
