class SearchesController < ApplicationController
  def index
    @searches = Search.all
  end

  def new
    @search = Search.new
  end

  def show
    @search = Search.find(params[:id])
    @potential_candidates = @search.potential_candidates
  end

  def create
    @search = Search.new(search_params)
    if @search.save
      run_search(@search)
      redirect_to @search, notice: "Search was successfully created."
    else
      render :new
    end
  end

  def analyze
    criteria = CriteriaExtractionService.new.call(params[:text])
    render json: {
      poste: criteria["poste"].present?,
      localisation: criteria["localisation"].present?,
      annees_experience: criteria["annees_experience"].present?,
      competences: criteria["competences"].present?,
      industrie: criteria["industrie"].present?
    }
  end

  def edit
    @search = Search.find(params[:id])
  end

  def update
    @search = Search.find(params[:id])
    if @search.update(search_params)
      redirect_to @search, notice: "Search was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @search = Search.find(params[:id])
    @search.destroy
    redirect_to searches_index_path, notice: "Search was successfully destroyed."
  end

  private

  # Runs the sourcing pipeline (criteria extraction → Exa search) and
  # persists the results for this search.
  def run_search(search)
    text = [search.job_title, search.job_description].compact_blank.join("\n")
    sourcing = SourcingService.new(text).call

    search_result = search.search_results.create!(
      query: sourcing[:query],
      raw_response: sourcing[:results],
      status: "completed"
    )

    build_potential_candidates(search_result, sourcing[:results])
  end

  def build_potential_candidates(search_result, exa_response)
    exa_response["results"].each do |result|
      search_result.potential_candidates.create!(candidate_attributes(result))
    end
  end

  def candidate_attributes(result)
    summary_data = parse_summary(result["summary"])
    url = result["url"].to_s
    {
      full_name: summary_data["name"].presence || result["title"],
      summary: [summary_data["headline"], summary_data["location"]].compact_blank.join(" — "),
      linkedin_url: url.include?("linkedin.com") ? url : nil,
      github_url: url.include?("github.com") ? url : nil,
      source_url: url
    }
  end

  def search_params
    params.require(:search).permit(:job_title, :job_description)
  end

  def parse_summary(summary)
    JSON.parse(summary.to_s)
  rescue JSON::ParserError
    {}
  end
end
