module Footprints
  class Craftsmen

    def initialize(craftsmen_source, topic_key)
      @craftsmen_source = craftsmen_source
      @topic_key = topic_key
    end

    def all
      employment.items(topic_key).map(&method(:from_employment))
    end

    def craftsman
      all.select { |c| c[:craftsman] }
    end

    def from_employment(item)
      {
        :craftsman       => has_tag?(item, "craftsman"),
        :first_name      => item["First Name"],
        :last_name       => item["Last Name"],
        :id              => item[:key],
        :email           => item["Email"]
      }
    end

    private
    attr_reader :employment, :topic_key

    def has_tag?(item, tag)
      tags = item[:tags] || []
      tags.include?(tag)
    end
  end
end
