class ApplicantValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    valid_craftsman
    craftsman_is_not_being_unassigned
    mentor_is_valid_craftsman
  end

  private

  attr_reader :record

  def valid_craftsman
    if record.assigned_craftsman.present? && craftsman_is_nil?
      record.errors.add(:assigned_craftsman, "Not a Valid Craftsman")
    end
  end

  def craftsman_is_not_being_unassigned
    if record.has_steward
      if record.assigned_craftsman_changed? && craftsman_is_nil?
        record.errors.add(:assigned_craftsman, "Can't un-assign Craftsman")
      end
    end
  end

  def mentor_is_valid_craftsman
    if !record.mentor.nil?
      if Footprints::Repository.craftsman.find_by_name(record.mentor).nil?
        record.errors.add(:mentor, "is not a valid craftsman")
      end
    end
  end

  def craftsman_is_nil?
    craftsman.nil?
  end

  def craftsman
    Footprints::Repository.craftsman.find_by_name(record.assigned_craftsman)
  end
end
