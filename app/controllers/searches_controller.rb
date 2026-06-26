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
      query = "#{@search.job_title} #{@search.job_description}"
      exa_response = ExaSearchService.new(query).call
      search_result = @search.search_results.create!(
        query: query,
        raw_response: exa_response,
        status: "completed"
      )

      exa_response["results"].each do |result|
        summary_data = JSON.parse(result.to_json)
        search_result.potential_candidates.create!(
          full_name: summary_data["name"],
          summary: summary_data["headline"],
          linkedin_url: summary_data["url"].include?("linkedin.com") ? summary_data["url"] : nil,
          github_url: summary_data["url"].include?("github.com") ? summary_data["url"] : nil,
          source_url: summary_data["url"]
        )
      end
      redirect_to @search, notice: "Search was successfully created."
    else
      render :new
    end
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

  def search_params
    params.require(:search).permit(:job_title, :job_description)
  end
end
