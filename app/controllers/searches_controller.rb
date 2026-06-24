class SearchesController < ApplicationController
  def index
    @searches = Search.all
  end

  def new
    @search = Search.new
  end

  def show
    @search = Search.find(params[:id])
  end

  def create
    @search = Search.new(search_params)
    if @search.save
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
