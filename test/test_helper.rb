require "rubygems"
require "minitest/autorun"
require "minitest/pride" # Colors show your testing pride
require "fakeweb"

unless ENV["LIVE"]
  FakeWeb.allow_net_connect = false
end
