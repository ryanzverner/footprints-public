require 'uri'

class UrlValidator < ActiveModel::Validator
  def validate(record)
    validate_url_format(record)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
  rescue URI::InvalidURIError
    false
  end

  private

  def validate_url_format(record)
    if record.code_submission
      unless valid_url?(record.code_submission) || record.code_submission.nil? || record.code_submission == ''
        record.errors.add(:code_submission, "URL is not valid")
      end
    end
  end
end
