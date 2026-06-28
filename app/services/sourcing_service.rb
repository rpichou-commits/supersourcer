class SourcingService
  # Orchestrates the full sourcing pipeline:
  #   free-form text
  #     → CriteriaExtractionService  (Claude extracts structured criteria)
  #     → build a search query from those criteria
  #     → ExaSearchService           (find matching LinkedIn people)
  def initialize(text, num_results: ExaSearchService::DEFAULT_NUM_RESULTS)
    @text = text
    @num_results = num_results
  end

  def call
    criteria = CriteriaExtractionService.new.call(@text)
    query = build_query(criteria)
    results = ExaSearchService.new(query, num_results: @num_results).call

    { criteria: criteria, query: query, results: results }
  end

  private

  # Turns the criteria hash into a natural-language query string for Exa.
  # Each segment is added only when the matching criterion is present, so an
  # incomplete request still produces a sensible query.
  def build_query(criteria)
    segments = []

    postes = Array(criteria["poste"]).reject(&:blank?)
    segments << postes.join(" or ") if postes.any?

    if (loc = criteria["localisation"]).present?
      segments << "based in #{loc}"
    end

    competences = Array(criteria["competences"]).reject(&:blank?)
    segments << "skilled in #{competences.join(', ')}" if competences.any?

    if (industrie = criteria["industrie"]).present?
      segments << "in the #{industrie} industry"
    end

    if (years = criteria["annees_experience"]).present?
      segments << "with at least #{years} years of experience"
    end

    # Fall back to the raw text if nothing usable was extracted.
    segments.any? ? segments.join(" ") : @text
  end
end
