class DateValidator < ActiveModel::Validator
  def validate(record)
    future_date_validation(record)
    date_sequence_validation(record)
  end

  private

  def future_date_validation(record)
    [:applied_on, :initial_reply_on, :sent_challenge_on, :completed_challenge_on, :reviewed_on, :offered_on, :decision_made_on].each do |field|
      if record.send(field)
        record.errors.add(field, "can't be in the future") if record.send(field) > DateTime.current
      end
    end
  end

  def date_sequence_validation(record)
    date_fields = [:applied_on, :initial_reply_on, :sent_challenge_on, :completed_challenge_on, :reviewed_on, :offered_on, :decision_made_on]
    date_fields.each_with_index  do |field, index|
      if record.send(field)
        date_fields[(index + 1)..-1].each do |later_field|
          if record.send(later_field)
            record.errors.add(field.upcase, "can't be after #{stringify_field_name(later_field)}") if record.send(field) > record.send(later_field)
          end
        end
      end
    end
  end

  def stringify_field_name(name)
    name_with_spaces = name.to_s.tr!('_', ' ')
    name_with_spaces.capitalize
  end

end
