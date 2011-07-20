require "test_helper"

describe Zendesk::Client::Users do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account ENDPOINT
      config.basic_auth EMAIL, PASSWORD
    end

    @user_id = ENV["LIVE"] ? @zendesk.users[-1]["id"] : 123
  end

  describe "GET" do
    it "all users" do
      users = @zendesk.users.fetch
      assert users.size > 0
    end

    it "single user by id" do
      user = @zendesk.users(@user_id).fetch
      assert user.name
    end

    it "currently authenticated user" do
      user = @zendesk.users(:current).fetch
      assert user.name
    end

    it "all users by query" do
      users = @zendesk.users("foo").fetch
      assert users.size > 0
      users.each do |u|
        assert u.name
      end
    end
  end

  describe "PUT" do
#     it "should update user with a hash" do
#       data = {:email => "blubber@corporation.com"}
#       @zendesk.update_user(@user_id, data)
#       user = @zendesk.users(@user_id)
#       assert user["email"] == "blubber@corporation.com"
#     end

    it "should update user with a block" do
      @zendesk.users(@user_id).update do |u|
        u[:email] = "blubber@corporation.com"
      end
      user = @zendesk.users(@user_id).fetch
      assert_equal "blubber@corporation.com", user.email
    end
  end

end
