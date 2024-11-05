# frozen_string_literal: true

require 'geocoder'

Geocoder.configure(
  use_https: true,
  http_headers: { 'User-Agent' => 'Chrome' },
  lookup: :nominatim,
  timeout: 3
)

module GeolocationService
  @address_cache = {}

  class << self
    def address_exists?(city, state, postal_code)
      return false unless valid_address_components?(city, state, postal_code)

      cache_key = generate_cache_key(city, state, postal_code)

      @address_cache.fetch(cache_key) do
        @address_cache[cache_key] = verify_address(city, state, postal_code)
      end
    end

    private

    def valid_address_components?(city, state, postal_code)
      city && state && postal_code
    end

    def generate_cache_key(city, state, postal_code)
      "#{city},#{state},#{postal_code}"
    end

    def verify_address(city, state, postal_code)
      full_address = "#{city}, #{state}, #{postal_code}"
      lookup_result = Geocoder.search(full_address)

      lookup_result.any? && lookup_result.first.postal_code == postal_code
    rescue StandardError
      false
    end
  end
end
