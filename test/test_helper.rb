require "rubygems"
require "minitest/autorun"
require "minitest/pride" # Colors show your testing pride
require "fakeweb"

$: << File.expand_path("../lib")
require "zendesk"

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + "/" + file).readlines.to_s
end

EXAMPLE_ID=123
unless ENV["LIVE"]
  FakeWeb.allow_net_connect = false

  Zendesk::Config::VALID_FORMATS.each do |format|
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users.#{format}", :body => fixture("users.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users/#{EXAMPLE_ID}.#{format}", :body => fixture("user.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users/current.#{format}", :body => fixture("user_current.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/organizations/#{EXAMPLE_ID}/users.#{format}", :body => fixture("users_of_org.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/groups/#{EXAMPLE_ID}/users.#{format}", :body => fixture("users_of_group.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users.#{format}?group=#{EXAMPLE_ID}", :body => fixture("users_of_group.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users.#{format}?organization=#{EXAMPLE_ID}", :body => fixture("users_of_org.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users.#{format}?query=Dylan", :body => fixture("user_current.#{format}"))
    FakeWeb.register_uri(:get, "https://mondocam.zendesk.com/users.#{format}?query=Dylan&role=2", :body => fixture("user_current.#{format}"))
  end
end
