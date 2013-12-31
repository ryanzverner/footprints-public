class CraftsmanValidator < ActiveModel::Validator
  def validate(record)
    @record = record
    past_date_validation(record)
  end

  private

  attr_reader :record

  def past_date_validation(record)
    if record.unavailable_until
      record.errors.add(:unavailable_until, "can't be in the past") if record.unavailable_until < Date.today
    end
  end
end
