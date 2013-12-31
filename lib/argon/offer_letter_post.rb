module OfferLetterPost
  def self.get_pdf(json_data, posting_service=HTTParty)
    response = posting_service.post(argon_url, body: build_params(json_data))
    response.body
  end

  private

  def self.argon_url
    "https://argon.abcinc.com/api/pdf"
  end

  def self.build_params(json_data)
    {"api-key" => ENV['ARGON-API-KEY'],
     "piccup" => json_data}
  end
end
