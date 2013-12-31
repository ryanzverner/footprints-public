class CraftsmenInteractor
  attr_reader :craftsman

  class InvalidData < RuntimeError
  end

  def initialize(craftsman)
    @craftsman = craftsman
  end

  def update(attributes)
    validate(attributes)

    craftsman.update!(attributes)
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidData.new(e.message)
  end

  private

  def validate(attributes)
    if attributes.symbolize_keys[:skill].to_i <= 0
      raise InvalidData.new('Please provide at least one skill')
    end
  end
end
