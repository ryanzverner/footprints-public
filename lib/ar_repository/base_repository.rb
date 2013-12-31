module ArRepository
  module BaseRepository
    def all
      model_class.all
    end

    def first
      model_class.first
    end

    def last
      model_class.last
    end

    def new(attributes = {})
      model_class.new(attributes)
    end

    def find(id)
      model_class.find(id)
    rescue ActiveRecord::RecordNotFound => e
      raise Footprints::RecordNotFound.new(e)
    end

    def create(attributes = {})
      model_class.create!(attributes)
    end

    def destroy(id)
      model_class.destroy(id)
    end

    def destroy_all(*args)
      model_class.destroy_all(*args)
    end

    def find_each(&block)
      model_class.find_each(&block)
    end

    def order(order)
      model_class.order(order)
    end
  end
end
