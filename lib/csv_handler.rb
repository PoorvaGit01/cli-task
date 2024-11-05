# frozen_string_literal: true

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

      next unless all_required_fields_present?(email, first_name, last_name)

      is_home_address_valid = validate_address(record, 'Residential Address')
      is_mailing_address_valid = validate_address(record, 'Postal Address')

      valid_records << record.to_csv if is_home_address_valid && is_mailing_address_valid
    end

    valid_records
  end

  private

  def all_required_fields_present?(*fields)
    fields.none? { |value| value.nil? || value.strip.empty? }
  end

  def validate_address(record, address_type)
    GeolocationService.address_exists?(
      record["#{address_type} Locality"],
      record["#{address_type} State"],
      record["#{address_type} Postcode"]
    )
  end
end
