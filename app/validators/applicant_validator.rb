class ApplicantValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    valid_crafter
    crafter_is_not_being_unassigned
    mentor_is_valid_crafter
  end

  private

  attr_reader :record

  def valid_crafter
    if record.assigned_crafter.present? && crafter_is_nil?
      record.errors.add(:assigned_crafter, "Not a Valid Crafter")
    end
  end

  def crafter_is_not_being_unassigned
    if record.has_steward
      if record.assigned_crafter_changed? && crafter_is_nil?
        record.errors.add(:assigned_crafter, "Can't un-assign Crafter")
      end
    end
  end

  def mentor_is_valid_crafter
    if !record.mentor.nil?
      if Footprints::Repository.crafter.find_by_name(record.mentor).nil?
        record.errors.add(:mentor, "is not a valid crafter")
      end
    end
  end

  def crafter_is_nil?
    crafter.nil?
  end

  def crafter
    Footprints::Repository.crafter.find_by_name(record.assigned_crafter)
  end
end
