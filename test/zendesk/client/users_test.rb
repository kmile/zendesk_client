require "test_helper"

describe Zendesk::Client::Users do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account = ENDPOINT
      config.basic_auth EMAIL, PASSWORD
    end

    @user_id = ENV["LIVE"] ? @zendesk.users[-1].id : 123
  end

  describe "GET" do
    it "all users" do
      users = @zendesk.users.fetch
      refute_empty users
    end

    it "single user by id" do
      user = @zendesk.users(@user_id).fetch
      refute_nil user
    end

    it "currently authenticated user" do
      user = @zendesk.users.current.fetch
      refute_nil user
    end

    it "all users by query" do
      unless ENDPOINT =~ /localhost/ # search on localhost is a pain
        users = @zendesk.users("foo").fetch
        refute_empty users
      end
    end
  end

  describe "POST" do
    it "should create a user with a hash" do
      user = @zendesk.users.create({:name => "Wu Tang"})
      assert_equal "Wu Tang", @zendesk.users(user.id).fetch.name
      @zendesk.users(user.id).delete
    end

    it "should create a user with a block" do
      user = @zendesk.users.create do |user|
        user[:name] = "Wu Tang"
      end
      assert_equal "Wu Tang", @zendesk.users(user.id).fetch.name
      @zendesk.users(user.id).delete
    end
  end

  describe "PUT" do
    it "should update user with a hash" do
      @zendesk.users(@user_id).update({:phone => "415-331-3333"})
      user = @zendesk.users(@user_id).fetch
      assert_equal "415-331-3333", user.phone
    end

    it "should update user with a block" do
      @zendesk.users(@user_id).update do |u|
        u[:phone] = "415-222-2222"
      end
      user = @zendesk.users(@user_id).fetch
      assert_equal "415-222-2222", user.phone
    end
  end

  describe "DELETE" do
    it "should delete user" do
      user = @zendesk.users.create({:name => "Hong Kong Phooey"})
      @zendesk.users(user.id).delete
      assert_raises(Zendesk::NotFound) { @zendesk.users(user.id).fetch }
    end
  end
end
