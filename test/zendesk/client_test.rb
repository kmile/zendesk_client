require "test_helper"

describe Zendesk::Client do
  it "should connect to the subdomain provided" do
    client = Zendesk::Client.new("mondocam")
    assert_equal "https://mondocam.zendesk.com", client.endpoint
    assert_equal "mondocam", client.subdomain
  end

  it "should accept email and password auth options" do
    client = Zendesk::Client.new("mondocam", :email => "dude@biz.com", :password => "sekret")
    assert_equal "dude@biz.com", client.email
    assert_match "sekret", client.password
  end
end
