require 'spec_helper'

describe "Advertisers" do
  after do
    ImpactRadiusAPI.auth_token = nil
    ImpactRadiusAPI.account_sid = nil
  end

  describe ".xml_field" do
    context "InvalidRequestError" do
      it "raise InvalidRequestError if not an advertisers resource" do
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{advertisers.xml_field("Other")}.to raise_error(ImpactRadiusAPI::InvalidRequestError)
      end
    end

    context "Conversions" do
      it "returns Conversions for resource Conversions" do
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect(advertisers.xml_field("Conversions")).to eq("Conversions")
      end
    end
  end

  describe ".get" do
    context "no or invalid auth_token" do
      it "raises authentication error if no auth_token" do
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
      end

      it "raises authentication error if auth_token has spaces" do
        ImpactRadiusAPI.auth_token = "xxxxx xxxxx"
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
      end

      it "raises authentication error if no Account SID" do
        ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
      end

      it "raises authentication error if account_sid (AccountSid) has space" do
        ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
        ImpactRadiusAPI.account_sid = "IRxxx xxx"
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
      end

      it "raises authentication error if Account SID doesn't start with IR" do
        ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
        ImpactRadiusAPI.account_sid = "ERxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
      end

      it "raises authentication error if Account SID doesn't have 34 chars" do
        ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
        ImpactRadiusAPI.account_sid = "IRxxxxxx"
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
      end
    end
    context "params is not a Hash" do
      it "raises ArgumentError if parms not a Hash" do
        ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
        ImpactRadiusAPI.account_sid = "IRxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        advertisers = ImpactRadiusAPI::Advertisers.new
        expect{ advertisers.get("Conversions", "user") }.to raise_error(ImpactRadiusAPI::ArgumentError)
      end
    end

    context "response 200" do
      before do
        xml_response = <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <ImpactRadiusResponse>
            <Status>QUEUED</Status>
            <QueuedUri>/Advertisers/IR4DBVmcabXH397784eDqh77mrvGfXb3y1/APISubmissions/A-776cc275-9014-4184-8f3e-e6254216b929</QueuedUri>
          </ImpactRadiusResponse>
          XML
        stub_request(
          :get,
          %r{https://..*:..*@api.impactradius.com/Advertisers/..*/Conversions?..*}).
        to_return(
          status: 200,
          body: xml_response,
          headers: { "Content-type" => "text/xml; charset=UTF-8" }
        )
        ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
        ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
      end

      let(:advertisers) {ImpactRadiusAPI::Advertisers.new}
      let(:params)  {{
        CampaignId: 5571,
        ActionTrackerId: 12_501,
        Oid: 'user-qpcxr83aaqk',
        CustomerId: 'user-qpcxr83aaqk',
        CustomerCountry: 'CA',
        Sku1: 'Wealthsimple Trade',
        Category1: 'CA Wealthsimple Trade',
        Amount1: 100,
        Quantity1: 1,
        EventDate: DateTime.now.iso8601(3),
      }}
      let(:response) {advertisers.get("Conversions", params)}

      it "trigger conversion" do
        expect(response).to eq({
          QueuedUri: "/Advertisers/IR4DBVmcabXH397784eDqh77mrvGfXb3y1/APISubmissions/A-776cc275-9014-4184-8f3e-e6254216b929"
          Status: "QUEUED"
        })
      end
    end
  end
end
