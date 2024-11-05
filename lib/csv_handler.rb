# lib/csv_handler.rb

require 'csv'
require_relative 'validators/address_validator'

class CsvHandler
  attr_reader :file_path, :valid_records

  def initialize(file_path)
    @file_path = file_path
    @valid_records = []
  end

  def execute
    CSV.foreach(file_path, headers: true) do |record|
      email, first_name, last_name = record.values_at('Email', 'First Name', 'Last Name')

      # Skip if any of the required fields are blank
      next unless all_required_fields_present?(email, first_name, last_name)

      # Validate the addresses
      is_home_address_valid = validate_address(record, 'Residential Address')
      is_mailing_address_valid = validate_address(record, 'Postal Address')

      # Only add the record if both addresses are valid
      if is_home_address_valid && is_mailing_address_valid
        valid_records << record.to_csv
      end
    end

    valid_records
  end

  private

  def all_required_fields_present?(*fields)
    fields.all? { |value| value && !value.strip.empty? } # Changed to all? to ensure all fields are checked
  end

  def validate_address(record, address_type)
    GeolocationService.address_exists?(
      record["#{address_type} Locality"],
      record["#{address_type} State"],
      record["#{address_type} Postcode"]
    )
  end
end
