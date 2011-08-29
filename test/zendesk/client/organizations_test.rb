require "test_helper"

describe Zendesk::Client::Organizations do
  before do
    @zendesk = Zendesk::Client.new do |config|
      config.account = ENDPOINT
      config.basic_auth EMAIL, PASSWORD
    end

    @organization_id = ENV["LIVE"] ? @zendesk.organizations[-1].id : 123
  end

  describe "GET" do
    it "all organizations" do
      organizations = @zendesk.organizations.fetch
      refute_empty organizations
    end

    it "single organization by id" do
      organization = @zendesk.organizations(@organization_id).fetch
      refute_nil organization
    end
  end

  describe "POST" do
    it "should create a organization with a hash" do
      organization = @zendesk.organizations.create({:name => "Wu Tang Clan"})
      assert_equal "Wu Tang Clan", organization.name
      @zendesk.organizations(organization.id).delete
    end

    it "should create a organization with a block" do
      organization = @zendesk.organizations.create do |organization|
        organization[:name] = "Wu Tang Clan"
      end
      assert_equal "Wu Tang Clan", organization.name
      @zendesk.organizations(organization.id).delete
    end
  end

  describe "PUT" do
    it "should update organization with a hash" do
      @zendesk.organizations(@organization_id).update({:name => "Souls of Mischief"})
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
      @zendesk.organizations(organization.id).delete
      assert_raises(Zendesk::NotFound) { @zendesk.organizations(organization["id"]).fetch }
    end
  end
end
