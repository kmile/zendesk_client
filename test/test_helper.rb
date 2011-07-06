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

#=======================
#  register fakeweb URIs
#=======================
if ENV["LIVE"]  # tests can be run live, overwriting SUBDOMAIN and EMAIL:PASSWORD
  abort("Must run with SUBDOMAIN='subdomain'") unless ENV["SUBDOMAIN"]
  abort("Must run with BASIC_AUTH='email:password'") unless ENV["BASIC_AUTH"]
  SUBDOMAIN       = ENV["SUBDOMAIN"]
  EMAIL, PASSWORD = ENV["BASIC_AUTH"].split(":")

else

  FakeWeb.allow_net_connect = false

  SUBDOMAIN       = "mondocam"
  EMAIL, PASSWORD = "fruity", "pebbles"
  prefix = %r| https://\w+:\w+@\w+\.zendesk\.com |x

  FORMATS = [:json] # Zendesk::Config::VALID_FORMATS
  FORMATS.each do |format|
    # Users
    # ---------------------
    FakeWeb.register_uri(:get, %r| #{prefix}/users\.#{format}                     |x, :body => fixture("users.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/users/\d+\.#{format}                 |x, :body => fixture("user.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/users/current\.#{format}             |x, :body => fixture("user_current.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/organizations/\d+/users\.#{format}   |x, :body => fixture("users_of_org.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/groups/\d+/users\.#{format}          |x, :body => fixture("users_of_group.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/users\.#{format}\\?query=\w+         |x, :body => fixture("user_current.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/users\.#{format}\\?query=\w+&role=\d |x, :body => fixture("user_current.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/users\.#{format}\\?group=\d+         |x, :body => fixture("users_of_group.#{format}"))
    FakeWeb.register_uri(:get, %r| #{prefix}/users\.#{format}\\?organization=\d+  |x, :body => fixture("users_of_org.#{format}"))

    # Etc
    # ---------------------

  end
end
