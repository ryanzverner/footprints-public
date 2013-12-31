module MemoryRepository
  module BaseRepository

    def save(object)
      object.id = records.size + 1 if object.id.nil?
      records[object.id] = object
    end

    def find(id)
      record = records[id.to_i]
      raise Footprints::RecordNotFound unless record
      record
    end

    def find_each(&block)
      records.each do |id, model|
        block.call(model)
      end
    end

    def delete(id)
      records.delete(id)
    end

    def destroy_all
      @records = {}
    end

    def records
      @records ||= {}
    end

    def order(args)
      args = args.split(" ")
      key = args[0]
      sort_type = args[1]
      if sort_type == "ASC"
        sorted = records.sort_by { |k, v| v.send(key)}.flatten
      else
        sorted = records.sort_by { |k, v| v.send(key) }.reverse.flatten
      end
      sorted
    end
  end
end
