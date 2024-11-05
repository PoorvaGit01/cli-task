# spec/address_validator_spec.rb


require 'rspec'
require 'validators/address_validator'
require 'geolocation_service'

RSpec.describe AddressValidator do
  describe '.valid?' do
    let(:record) do
      {
        'Home Locality' => 'San Francisco',
        'Home State' => 'CA',
        'Home Postcode' => '94105'
      }
    end

    context 'when the address exists' do
      before do
        allow(GeolocationService).to receive(:address_exists?).and_return(true)
      end

      it 'returns true for a valid address' do
        expect(AddressValidator.valid?(record, 'Home')).to be true
      end
    end

    context 'when the address does not exist' do
      before do
        allow(GeolocationService).to receive(:address_exists?).and_return(false)
      end

      it 'returns false for an invalid address' do
        expect(AddressValidator.valid?(record, 'Home')).to be false
      end
    end

    context 'when the address type is invalid' do
      it 'returns false for an invalid address type' do
        expect(AddressValidator.valid?(record, 'InvalidType')).to be false
      end
    end
  end
end
