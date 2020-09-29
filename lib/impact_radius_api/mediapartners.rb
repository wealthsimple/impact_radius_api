module ImpactRadiusAPI
  class Mediapartners < APIResource
    def xml_field(resource)
      case resource
      when "Ads"
        "Ads"
      when "PromoAds"
        "PromotionalAds"
      when "ActionInquiries"
        "ActionInquiries"
      when "Campaigns"
        "Campaigns"
      when "Actions"
        "Actions"
      when "Catalogs"
        "Catalogs"
      when "Items"
        "Items"
      when "Catalogs/ItemSearch"
        "Items"
      when /Catalogs\/\d{3,5}\/Items/
        "Items"
      else
        raise InvalidRequestError.new("#{resource} is not a valid Media Partner Resources. Refer to: http://dev.impactradius.com/display/api/Media+Partner+Resources for valid Media Partner Resources.")
      end
    end

    def process(response)
      case response.code
      when 200, 201, 204
        MediaPartnersApiResponse.new(response, @resource)
      when 400, 404
        raise InvalidRequestError.new(response["ImpactRadiusResponse"]["Message"], response.code)
      when 401
        raise AuthenticationError.new(response.body, response.code)
      else
        raise Error.new(response["ImpactRadiusResponse"]["Message"], response.code)
      end
    end
  end
end
