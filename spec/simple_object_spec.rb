require 'spec_helper'

class PaySimple::TestSimpleObject < PaySimple::SimpleObject
  required_attributes :name
  belongs_to :other_test_object, class_name: "TestSimpleObject"
  belongs_to :serialized_object, class_name: "TestSimpleObject", serialize: true
end

describe PaySimple::SimpleObject do
  let(:instance) { PaySimple::TestSimpleObject.new }

  context '#valid' do

    it "isn't valid if it doesn't have a value for all the required attributes" do 
      expect(instance).not_to be_valid
    end

    it "is valid if it has a value for it's required attributes" do 
      instance.name = "test"
      expect(instance).to be_valid
    end
  end

  it "allows initialization via a hash of attributes" do 
    initialized = PaySimple::TestSimpleObject.new({
      name: "Test"
    })

    expect(initialized.name).to eq "Test"
  end

  it "can set and access associations" do 
    expect(PaySimple::TestSimpleObject.associations.size).to eq 2
  end 

  it "should include serialized associations in the json output" do 
    instance.serialized_object = PaySimple::TestSimpleObject.new
    expect(instance.as_json['SerializedObject']).not_to be_nil
  end

end