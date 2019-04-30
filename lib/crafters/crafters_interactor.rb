class CraftersInteractor
  attr_reader :crafter

  class InvalidData < RuntimeError
  end

  def initialize(crafter)
    @crafter = crafter
  end

  def update(attributes)
    validate(attributes)

    crafter.update!(attributes)
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
