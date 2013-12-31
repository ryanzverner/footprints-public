class NotePresenter
  def initialize(note)
    @note = note
  end

  def id
    @note.id
  end

  def body
    @note.body
  end

  def craftsman
    @note.craftsman.name rescue "Unknown"
  end

  def updated_at
    @note.updated_at.strftime("%l:%M%p - %m/%d/%Y")
  end

  def created_by?(user)
    user.craftsman_id == @note.craftsman_id
  end
end
