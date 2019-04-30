module Warehouse
  class CraftersSync
    def initialize(api)
      @api = api
    end

    def sync
      remove_crafters
      unarchive_crafters
      create_crafters
    end

    private

    def repo
      Footprints::Repository
    end

    def remove_crafters
      repo.crafter.all.each do |crafter|
        crafter.flag_archived! unless crafter_in_warehouse?(crafter)
      end
    end

    def create_crafters
      @api.current_crafters.each do |crafter|
        update_or_create_crafter(crafter)
      end
    end

    def unarchive_crafters
      repo.crafter.unscoped.each do |crafter|
        crafter.update_attributes(:archived => false) if crafter_in_warehouse?(crafter)
      end
    end

    def update_or_create_crafter(crafter)
      if footprints_crafter = repo.crafter.unscoped.find_by_employment_id(crafter[:id])
        footprints_crafter.update_attributes(prepare_crafter_attrs(crafter))
      else
        footprints_crafter = repo.crafter.create(prepare_crafter_attrs(crafter))
      end
      associate_user(footprints_crafter)
    rescue Footprints::RecordNotValid => error
      puts "#{error}: #{error.record}"
    end

    def associate_user(crafter)
      user = User.find_by_email(crafter.email)
      user.update_attributes(:crafter_id => crafter.employment_id) if user
    end

    def crafter_in_warehouse?(crafter)
      warehouse_ids.include?(crafter.employment_id)
    end

    def crafter_exists?(attrs)
      repo.crafter.find_by_email(attrs[:person][:email]).present?
    end

    def prepare_crafter_attrs(attrs)
      {:name => "#{attrs[:person][:first_name]} #{attrs[:person][:last_name]}", :email => attrs[:person][:email], :employment_id => attrs[:id], :position => attrs[:position][:name]}
    end

    def warehouse_ids
      @api.current_crafters.collect{ |crafter| crafter[:id] }
    end
  end
end

