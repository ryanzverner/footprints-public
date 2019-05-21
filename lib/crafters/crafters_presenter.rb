require './lib/crafters/skills'

class CraftersPresenter
  def initialize(crafters)
    @crafters = crafters
  end

  def seeking_resident_apprentice
    @crafters.where("seeking = ?", true).where("skill = ?", Skills.get_key_for_skill("Resident"))
  end

  def seeking_student_apprentice
    @crafters.where("seeking = ?", true).where("skill = ?", Skills.get_key_for_skill("Student"))
  end
end
