require "test_helper"

describe Zendesk::Client::Users do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account ENDPOINT
      config.basic_auth EMAIL, PASSWORD
    end

    @organization_id = ENV["LIVE"] ? @zendesk.organizations[-1]["id"] : 123
  end

  describe "GET" do
    it "all organizations" do
      organizations = @zendesk.organizations.fetch
      assert organizations.size > 0
    end

    it "single organization by id" do
      organization = @zendesk.organizations(@organization_id).fetch
      assert organization.name
    end
  end

  describe "POST" do
    it "should create a organization with a hash" do
      data = {:name => "Wu Tang Clan"}
      organization = @zendesk.organizations.create(data)
      assert_equal "Wu Tang Clan", organization.name
      @zendesk.organizations(organization["id"]).delete
    end

    it "should create a organization with a block" do
      organization = @zendesk.organizations.create do |organization|
        organization[:name] = "Wu Tang Clan"
      end
      assert_equal "Wu Tang Clan", organization.name
      @zendesk.organizations(organization["id"]).delete
    end
  end

  describe "PUT" do
    it "should update organization with a hash" do
      data = {:name => "Souls of Mischief"}
      @zendesk.organizations(@organization_id).update(data)
      organization = @zendesk.organizations(@organization_id).fetch
      assert_equal "Souls of Mischief", organization.name
    end

    it "should update organization with a block" do
      organization = @zendesk.organizations(@organization_id).update do |u|
        u[:name] = "Madvillian"
      end
      assert_equal "Madvillian", organization.name
    end
  end

  describe "DELETE" do
    it "should delete organization" do
      organization = @zendesk.organizations.create({:name => "Visionaries"})
      @zendesk.organizations(organization["id"]).delete
    end
  end

end
