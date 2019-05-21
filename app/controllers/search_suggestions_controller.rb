class SearchSuggestionsController < ApplicationController
  def index
    render json: get_name_suggestions(params[:term])
  end

  def crafter_suggestions 
    render json: get_crafter_suggestions(params[:term])
  end

  private

  def get_name_suggestions(prefix)
    suggestions = []
    results = repo.applicant.where("name like ?", "%#{prefix}%").limit(10)
    results.each { |a| suggestions << a.name }
    suggestions
  end

  def get_crafter_suggestions(prefix)
    suggestions = []
    results = repo.crafter.where("name like ?", "%#{prefix}%").limit(10)
    results.each { |a| suggestions << a.name }
    suggestions
  end

end
