require 'spec_helper'

describe "impact_radius_api" do
  describe ".api_timeout" do
    context "time out integer and valid" do

      it "valid time sets @api_timeout" do
        ImpactRadiusAPI.api_timeout = 45
        expect(ImpactRadiusAPI.api_timeout).to eq(45)
      end
    end

    context "not valid timeout" do

      it "rasie Argument error if api_timeout is a string" do
        expect{ ImpactRadiusAPI.api_timeout = "45"}.to raise_error(ImpactRadiusAPI::ArgumentError,"Timeout must be a Fixnum; got String instead")
      end

      it "raise Argument error if api_timeout is below zero" do
        expect{ ImpactRadiusAPI.api_timeout = 0 }.to raise_error(ImpactRadiusAPI::ArgumentError,"Timeout must be > 0; got 0 instead")
      end
    end
  end

  describe "ImpactRadiusAPI::APIResource" do
    describe ".class_name" do

      context "MediaPartners" do
        it "should return class name" do
          resource = ImpactRadiusAPI::Mediapartners.new
          expect(resource.class_name).to eq("Mediapartners")
        end
      end

      context "Advertisers" do
        it "should return class name" do
          resource = ImpactRadiusAPI::Mediapartners.new
          expect(resource.class_name).to eq("Mediapartners")
        end
      end
    end

    describe ".base_path" do
      it "should return error if APIResource" do
        resource = ImpactRadiusAPI::APIResource.new
        expect{resource.base_path}.to raise_error(ImpactRadiusAPI::NotImplementedError)
      end

      it "returns base_path /Mediapartners/" do
        resource = ImpactRadiusAPI::Mediapartners.new
        expect(resource.base_path).to eq("/Mediapartners/")
      end

      it "returns base_path /Advertisers/" do
        resource = ImpactRadiusAPI::Advertisers.new
        expect(resource.base_path).to eq("/Advertisers/")
      end
    end
  end
end
