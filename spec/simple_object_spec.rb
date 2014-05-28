require 'spec_helper'

describe PaySimple::SimpleObject do

  context '#valid' do
    let(:subclass) { 
      class TestObject < PaySimple::SimpleObject
        required_attributes :name
      end
      TestObject.new
    }
    it "isn't valid if it doesn't have a value for all the required attributes" do 
      expect(subclass).not_to be_valid
    end

    it "is valid if it has a value for it's required attributes" do 
      subclass.name = "test"
      expect(subclass).to be_valid
    end
  end

end