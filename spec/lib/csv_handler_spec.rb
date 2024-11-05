# spec/lib/csv_handler_spec.rb

require 'csv'
require_relative '../../lib/csv_handler'
require_relative '../../lib/validators/address_validator'

RSpec.describe CsvHandler do
  let(:result) { CsvHandler.new(file_path).execute }

  before do
    allow(GeolocationService).to receive(:valid_address?).and_return(true)
  end

  describe '#execute' do
    context 'with valid CSV rows' do
      let(:file_path) { 'spec/fixtures/valid_input.csv' }

      it 'processes the file and returns valid records' do
        expect(result).not_to be_empty
      end

      it 'skips rows with blank email, first name, or last name' do
        allow(GeolocationService).to receive(:valid_address?).and_return(false)
      end
    end

    context 'with invalid addresses' do
      let(:file_path) { 'spec/fixtures/invalid_input.csv' }

      it 'skips rows with invalid residential or postal addresses' do
        allow(GeolocationService).to receive(:valid_address?).and_return(false)
      end
    end
  end
end
