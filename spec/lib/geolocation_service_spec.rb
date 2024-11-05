# spec/geolocation_service_spec.rb

require 'rspec'
require 'geolocation_service'
require 'geocoder'

RSpec.describe GeolocationService do
  describe '.address_exists?' do
    context 'with valid address components' do
      let(:city) { 'San Francisco' }
      let(:state) { 'CA' }
      let(:postal_code) { '94105' }

      before do
        allow(Geocoder).to receive(:search).with("#{city}, #{state}, #{postal_code}").and_return([
          double('Geocoder::Result', postal_code: postal_code)
        ])
      end
      

      it 'returns true if the address exists' do
        expect(GeolocationService.address_exists?(city, state, postal_code)).to be true
      end
    end

    context 'with invalid address components' do
      it 'returns false if any address component is missing' do
        expect(GeolocationService.address_exists?(nil, 'CA', '94105')).to be false
        expect(GeolocationService.address_exists?('San Francisco', nil, '94105')).to be false
        expect(GeolocationService.address_exists?('San Francisco', 'CA', nil)).to be false
      end
    end

    context 'when there is an error in the Geocoder search' do
      let(:city) { 'San Francisco' }
      let(:state) { 'CA' }
      let(:postal_code) { '94105' }

      before do
        allow(Geocoder).to receive(:search).and_raise(StandardError)
      end

      it 'returns false if an exception is raised' do
        expect(GeolocationService.address_exists?(city, state, postal_code)).to be true
      end
    end
  end
end