module Footprints
  class Crafters

    def initialize(crafters_source, topic_key)
      @crafters_source = crafters_source
      @topic_key = topic_key
    end

    def all
      employment.items(topic_key).map(&method(:from_employment))
    end

    def crafter
      all.select { |c| c[:crafter] }
    end

    def from_employment(item)
      {
        :crafter       => has_tag?(item, "crafter"),
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
