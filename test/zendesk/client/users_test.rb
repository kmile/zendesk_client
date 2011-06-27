require "test_helper"

describe Zendesk::Client::Users do
#   Zendesk::Config::VALID_FORMATS.each do |format|   # ParseXML middleware busted
  [:json].each do |format|
    before do
      @zendesk = Zendesk::Client.new("mondocam", :format => format)
    end

    it "should return list of users" do
      assert @zendesk.users(:all).size > 0
    end

    it "should return a specific user" do
      assert_equal "Dylan Clendenin", @zendesk.users(EXAMPLE_ID)["name"]
      assert_equal "Dylan Clendenin", @zendesk.users("Dylan")["name"]
    end

    it "should return the currently authenticated user" do
      assert_equal "Dylan Clendenin", @zendesk.users(:current)["name"]
    end

    it "should return users for an organization" do
      assert @zendesk.users(:organization => EXAMPLE_ID).size > 0
    end

    it "should return users for a group" do
      assert @zendesk.users(:group => EXAMPLE_ID).size > 0
    end
  end
end
