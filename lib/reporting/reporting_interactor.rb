require 'warehouse/json_api'
require 'warehouse/token_http_client'
require './lib/reporting/data_parser'
require './lib/reporting/employment_data_generator'
require './lib/warehouse/api_factory'
require './lib/warehouse/fake_api'

class ReportingInteractor

  class AuthenticationError < RuntimeError
  end

  attr_reader :auth_token

  def initialize(auth_token)
    @auth_token = auth_token
  end

  def fetch_projection_data(month, year, months = 12)
    parser = DataParser.new(fetch_all_employments, fetch_all_apprenticeships)
    projection_data(parser, projection_range(month, year, months))
  end

  def fetch_all_employments
    warehouse.find_all_employments
  rescue Warehouse::AuthenticationError, Warehouse::AuthorizationError => e
    raise AuthenticationError.new(e.message)
  end

  def fetch_all_apprenticeships
    warehouse.find_all_apprenticeships
  end

  private

  def warehouse
    client = Warehouse::TokenHttpClient.new(host: WAREHOUSE_URL, id_token: auth_token)
    Warehouse::APIFactory.create(client)
  end

  def projection_data(parser, range)
    generator = EmploymentDataGenerator.new(parser)

    range.reduce({}) do |resulting_hash, month|
      resulting_hash[month] = generator.generate_data_for(month)
      resulting_hash
    end
  end

  def projection_range(month, year, months)
    start_date = Date.parse("#{month}/#{year}")
    end_date = Date.parse("#{month}/#{year}") >> months

    date_range = (start_date..end_date)
    date_range.map { |date| date.strftime("%b %Y") }.uniq
  end
end
