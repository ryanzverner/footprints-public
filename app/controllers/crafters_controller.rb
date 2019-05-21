require './lib/repository'
require './lib/crafters/crafters_interactor'
require './lib/crafters/crafters_presenter'
require './lib/crafters/skills'

class CraftersController < ApplicationController
  before_filter :authenticate, :employee?
  before_filter :normalize_status, :only => [:index]

  def profile
    @crafter = current_user.crafter
  end

  def seeking
    crafters_presenter = CraftersPresenter.new(Footprints::Repository.crafter)
    @crafters_seeking_residents = crafters_presenter.seeking_resident_apprentice
    @crafters_seeking_students  = crafters_presenter.seeking_student_apprentice
  end

  def update
    @crafter = current_user.crafter
    interactor = CraftersInteractor.new(@crafter)
    interactor.update(crafter_params)

    redirect_to profile_path, :notice => "Successfully saved profile"
  rescue CraftersInteractor::InvalidData => e
    @crafter.attributes = crafter_params

    flash.now[:error] = [e.message]
    render :profile
  end

  private

  def normalize_status
    if params["crafter"]
      params["crafter"]["status"] = params["crafter"]["status"].titleize
    end
  end

  def crafter_params
    params.require(:crafter).permit(:status, :has_apprentice, :seeking, :skill, :location, :unavailable_until)
  end
end
