class NotesController < ApplicationController
  def create
    note = Note.new(note_params)

    if crafter.present?
      note.update_attribute(:crafter_id, crafter.id)
    end

    redirect_to applicant_path(note.applicant), :notice => ("Only crafters can leave notes." if crafter.nil?)
  end

  def edit
    @note = Note.find(params[:id])
    render :partial => 'applicants/note_edit_form'
  end

  def update
    note = Note.find(params[:id])

    if crafter.present?
      note.update_attributes(note_params)
    end

    redirect_to applicant_path(note.applicant), :notice => ("Only crafters can edit notes." if crafter.nil?)
  end

  private

  def crafter
    current_user.crafter
  end

  def note_params
    params.require(:note).permit(:body, :applicant_id)
  end
end
