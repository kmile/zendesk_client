require "test_helper"

describe Zendesk::Client::Users do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account ENDPOINT
      config.basic_auth EMAIL, PASSWORD
    end
  end

  describe "GET" do
    it "all users" do
      users = @zendesk.users
      @user_id = users[0]["id"]
      assert users.size > 0
      users.each do |u|
        assert u["name"]
      end
    end

    it "single user by id" do
      user = @zendesk.users(@user_id)
      assert user["name"]
    end

    it "currently authenticated user" do
      user = @zendesk.users(:current)
      assert @zendesk.users(:current)["name"]
    end
  end

#   describe "PUT" do
#     FORMATS.each do |format|
#       it "should update user with a hash" do
#         data = {:email => "blubber@corporation.com"}
#         @zendesk.update_user(123)
#         user = @zendesk.users(123)
#         assert user["email"] == "blubber@corporation.com"
#       end

#       it "should update user with a block" do
#         @zendesk.update_user(123) do |u|
#           u["email"] = "blubber@corporation.com"
#         end
#         user = @zendesk.users(123)
#         assert user["email"] == "blubber@corporation.com"
#       end
#     end
#   end

end
