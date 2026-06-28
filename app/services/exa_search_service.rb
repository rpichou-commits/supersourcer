class ExaSearchService
  include HTTParty
  base_uri "https://api.exa.ai"

  DEFAULT_NUM_RESULTS = 10

  class Error < StandardError; end

  def initialize(query, num_results: DEFAULT_NUM_RESULTS)
    @query = query
    @num_results = num_results
  end

  def call
    api_key = ENV["EXA_API_KEY"]
    raise Error, "EXA_API_KEY is not set" if api_key.blank?

    response = self.class.post(
      "/search",
      headers: {
        "x-api-key" => api_key,
        "Content-Type" => "application/json"
      },
      body: {
        query: @query,
        category: "people",
        includeDomains: ["linkedin.com"],
        numResults: @num_results,
        contents: {
          summary: {
            schema: {
              type: "object",
              properties: {
                name:     { type: "string", description: "The person's full name only" },
                headline: { type: "string", description: "Their current job title" },
                location: { type: "string" }
              }
            }
          }
        }
      }.to_json
    )

    unless response.success?
      raise Error, "Exa API returned #{response.code}: #{response.body}"
    end

    parsed = response.parsed_response   # HTTParty already turned JSON into a Ruby hash
    parsed["results"] ||= []
    parsed
  end
end
