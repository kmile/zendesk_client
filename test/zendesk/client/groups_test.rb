require "test_helper"

describe Zendesk::Client::Users do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account = ENDPOINT
      config.basic_auth EMAIL, PASSWORD
    end

    @group_id = ENV["LIVE"] ? @zendesk.groups[-1]["id"] : 123
  end

  describe "GET" do
    it "all groups" do
      groups = @zendesk.groups.fetch
      assert groups.size > 0
    end

    it "single group by id" do
      group = @zendesk.groups(@group_id).fetch
      assert group.name
    end
  end

  describe "POST" do
    it "should create a group with a hash" do
      data = {:name => "Wu Tang Clan"}
      group = @zendesk.groups.create(data)
      assert_equal "Wu Tang Clan", group.name
      @zendesk.groups(group["id"]).delete
    end

    it "should create a group with a block" do
      group = @zendesk.groups.create do |group|
        group[:name] = "Wu Tang Clan"
      end
      assert_equal "Wu Tang Clan", group.name
      @zendesk.groups(group["id"]).delete
    end
  end

  describe "PUT" do
    it "should update group with a hash" do
      data = {:name => "Souls of Mischief"}
      @zendesk.groups(@group_id).update(data)
      group = @zendesk.groups(@group_id).fetch
      assert_equal "Souls of Mischief", group.name
    end

    it "should update group with a block" do
      group = @zendesk.groups(@group_id).update do |u|
        u[:name] = "Madvillian"
      end
      assert_equal "Madvillian", group.name
    end
  end

  describe "DELETE" do
    it "should delete group" do
      group = @zendesk.groups.create({:name => "Visionaries"})
      @zendesk.groups(group["id"]).delete

      # will 404 now
    end
  end

end
