# frozen_string_literal: true

require_relative '../geolocation_service'

class AddressValidator
  class << self
    def valid?(record, address_type)
      GeolocationService.address_exists?(
        record["#{address_type} Locality"],
        record["#{address_type} State"],
        record["#{address_type} Postcode"]
      )
    end
  end
end
