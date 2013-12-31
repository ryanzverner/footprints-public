class SearchSuggestionsController < ApplicationController
  def index
    render json: get_name_suggestions(params[:term])
  end

  def craftsman_suggestions 
    render json: get_craftsman_suggestions(params[:term])
  end

  private

  def get_name_suggestions(prefix)
    suggestions = []
    results = repo.applicant.where("name like ?", "%#{prefix}%").limit(10)
    results.each { |a| suggestions << a.name }
    suggestions
  end

  def get_craftsman_suggestions(prefix)
    suggestions = []
    results = repo.craftsman.where("name like ?", "%#{prefix}%").limit(10)
    results.each { |a| suggestions << a.name }
    suggestions
  end

end
