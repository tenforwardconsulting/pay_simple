require "pay_simple/version"
require "pay_simple/client"
require "pay_simple/simple_object"
require "pay_simple/customer"
require "pay_simple/address"
require "pay_simple/account/ach"

module PaySimple
  @api_key = nil
  @api_user = nil

  def self.api_key
    @api_key
  end

  def self.api_key=(key)
    @api_key=key
  end

  def self.api_user
    @api_user
  end

  def self.api_user=(user)
    @api_user=user
  end
end
