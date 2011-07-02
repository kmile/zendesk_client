require "test_helper"

describe Zendesk::Client do
  it "should connect to the subdomain provided" do
    client = Zendesk::Client.new do |config|
      config.account SUBDOMAIN
    end
    assert_equal "https://#{SUBDOMAIN}.zendesk.com", client.endpoint
    assert_equal SUBDOMAIN, client.subdomain
  end

  it "should accept email and password auth options" do
    client = Zendesk::Client.new(:account => SUBDOMAIN, :email => EMAIL, :password => PASSWORD)
    assert_equal EMAIL, client.email
    assert_match PASSWORD, client.password
  end
end
