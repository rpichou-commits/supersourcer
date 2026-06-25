require "net/http"
require "json"

# Queries the Exa search API (https://exa.ai) and returns the parsed response.
#
# Usage:
#   ExaSearchService.new("Full-stack Ruby developer in Paris").call
#   # => { "results" => [ { "title" => ..., "url" => ..., "highlights" => [...] }, ... ] }
class ExaSearchService
  ENDPOINT = "https://api.exa.ai/search".freeze
  DEFAULT_NUM_RESULTS = 10

  class Error < StandardError; end

  def initialize(query, num_results: DEFAULT_NUM_RESULTS)
    @query = query
    @num_results = num_results
  end

  def call
    api_key = ENV["EXA_API_KEY"]
    raise Error, "EXA_API_KEY is not set" if api_key.blank?

    uri = URI(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 30

    request = Net::HTTP::Post.new(uri)
    request["x-api-key"] = api_key
    request["Content-Type"] = "application/json"
    request["Accept"] = "application/json"
    request.body = {
      query: @query,
      type: "auto",
      numResults: @num_results,
      contents: { highlights: true }
    }.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      raise Error, "Exa API returned #{response.code}: #{response.body}"
    end

    parsed = JSON.parse(response.body)
    parsed["results"] ||= []
    parsed
  end
end
