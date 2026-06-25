class CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all
  end

  def create
    @search = Search.find(params[:search_id])

    potential_candidate = PotentialCandidate.find(params[:potential_candidate_id])

    @candidate = @search.candidates.new(
      full_name: potential_candidate.full_name,
      summary: potential_candidate.summary,
      linkedin_profile: potential_candidate.linkedin_url,
      github_profile: potential_candidate.github_url
    )

    if @candidate.save
      redirect_to search_path(@search), notice: "Candidate saved."
    else
      redirect_to search_path(@search), alert: "Candidate could not be saved."
    end
  end

  def destroy
    @search = Search.find(params[:search_id])
    @candidate = @search.candidates.find(params[:id])
    @candidate.destroy
    redirect_to search_path(@search), notice: "Candidate was successfully destroyed."
  end
end
