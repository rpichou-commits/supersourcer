class CriteriaExtractionService
  include HTTParty
  base_uri "https://api.anthropic.com"

  class Error < StandardError; end

  MODEL = "Haiku-1" # Claude's smallest model, fast and cheap. Use "claude-v1" for better quality.

  # JSON Schema describing the criteria we want Claude to extract.
  # Passing this via `output_config.format` forces Claude's reply to match
  # it exactly, so we get reliable JSON instead of free-form prose.
  CRITERIA_SCHEMA = {
    type: "object",
    additionalProperties: false, # required by structured outputs
    properties: {
      localisation: {
        type: ["string", "null"],
        description: "Lieu recherché (ville, région ou pays). null si non précisé."
      },
      poste: {
        type: "array",
        items: { type: "string" },
        description: "Intitulés de poste recherchés, ex. ['Développeur Backend', 'Ingénieur logiciel']."
      },
      annees_experience: {
        type: ["integer", "null"],
        description: "Nombre minimum d'années d'expérience demandé. null si non précisé."
      },
      competences: {
        type: "array",
        items: { type: "string" },
        description: "Compétences / technologies demandées, ex. ['Ruby', 'Rails']."
      },
      industrie: {
        type: ["string", "null"],
        description: "Secteur d'activité visé, ex. 'Fintech'. null si non précisé."
      }
    },
    # Structured outputs require every property to be listed in `required`;
    # we make a field "optional" by allowing null in its type instead.
    required: %w[localisation poste annees_experience competences industrie]
  }.freeze

  def call(text)
    api_key = ENV["ANTHROPIC_API_KEY"]
    raise Error, "ANTHROPIC_API_KEY is not set" if api_key.blank?

    response = self.class.post(
      "/v1/messages",
      headers: {
        "x-api-key" => api_key,
        "anthropic-version" => "2023-06-01",
        "content-type" => "application/json"
      },
      body: {
        model: "claude-haiku-4-5",
        max_tokens: 1024,
        # Forces a JSON reply shaped like CRITERIA_SCHEMA.
        output_config: {
          format: { type: "json_schema", schema: CRITERIA_SCHEMA }
        },
        messages: [
          {
            role: "user",
            content: "Extrais les critères de recherche du texte suivant :\n\n#{text}"
          }
        ]
      }.to_json
    )

    unless response.success?
      raise Error, "Anthropic API returned #{response.code}: #{response.body}"
    end

    parsed = response.parsed_response

    # Claude can decline a request for safety reasons; the reply then has
    # no usable content, so guard before reading it.
    if parsed["stop_reason"] == "refusal"
      raise Error, "Anthropic refused the request"
    end

    # Two layers of JSON: HTTParty decoded the outer API envelope, and the
    # structured criteria live as a JSON string inside content[0]["text"].
    json_text = parsed.dig("content", 0, "text")
    raise Error, "No content returned: #{parsed}" if json_text.nil?

    JSON.parse(json_text) # → Ruby hash with our 5 criteria keys
  end
end
