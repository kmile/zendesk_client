require "test_helper"

describe Zendesk::Client::Users do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account SUBDOMAIN
      config.basic_auth EMAIL, PASSWORD
    end
  end

  describe "GET" do
    FORMATS.each do |format|
      it "should return list of users" do
        assert @zendesk.users.size > 0
        @zendesk.users.each do |u|
          assert u["name"]
        end
      end

      it "should return a specific user" do
        user = @zendesk.users(123)
        assert_equal "Dylan Clendenin", user["name"]
      end

      it "should return the currently authenticated user" do
        assert_equal "Dylan Clendenin", @zendesk.users(:current)["name"]
      end

      it "should return users for an organization" do
        assert @zendesk.users(:organization => 123).size > 0
      end

      it "should return users for a group" do
        assert @zendesk.users(:group => 123).size > 0
      end
    end
  end

  describe "PUT" do
    FORMATS.each do |format|
      it "should update user" do
        @zendesk.users(123).update do |u|
          u["email"] = "blubber@corporation.com"
        end
        user = @zendesk.users(123)
        assert user["email"] == "blubber@corporation.com"
      end
    end
  end

end
