module ImpactRadiusAPI
  class Advertisers < APIResource
    def xml_field(resource)
      case resource
      when "Conversions"
        "Conversions"
      else
        raise InvalidRequestError, "#{resource} is not a valid Advertiser Resource. Refer to: https://developer.impact.com/default/documentation/Adv-v8 for valid Advertiser Resources."
      end
    end

    def process(response)
      case response.code
      when 200, 201, 204
        response['ImpactRadiusResponse']
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
