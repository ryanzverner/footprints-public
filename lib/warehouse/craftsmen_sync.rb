module Warehouse
  class CraftsmenSync
    def initialize(api)
      @api = api
    end

    def sync
      remove_craftsmen
      unarchive_craftsmen
      create_craftsmen
    end

    private

    def repo
      Footprints::Repository
    end

    def remove_craftsmen
      repo.craftsman.all.each do |craftsman|
        craftsman.flag_archived! unless craftsman_in_warehouse?(craftsman)
      end
    end

    def create_craftsmen
      @api.current_craftsmen.each do |craftsman|
        update_or_create_craftsman(craftsman)
      end
    end

    def unarchive_craftsmen
      repo.craftsman.unscoped.each do |craftsman|
        craftsman.update_attributes(:archived => false) if craftsman_in_warehouse?(craftsman)
      end
    end

    def update_or_create_craftsman(craftsman)
      if footprints_craftsman = repo.craftsman.unscoped.find_by_employment_id(craftsman[:id])
        footprints_craftsman.update_attributes(prepare_craftsman_attrs(craftsman))
      else
        footprints_craftsman = repo.craftsman.create(prepare_craftsman_attrs(craftsman))
      end
      associate_user(footprints_craftsman)
    rescue Footprints::RecordNotValid => error
      puts "#{error}: #{error.record}"
    end

    def associate_user(craftsman)
      user = User.find_by_email(craftsman.email)
      user.update_attributes(:craftsman_id => craftsman.employment_id) if user
    end

    def craftsman_in_warehouse?(craftsman)
      warehouse_ids.include?(craftsman.employment_id)
    end

    def craftsman_exists?(attrs)
      repo.craftsman.find_by_email(attrs[:person][:email]).present?
    end

    def prepare_craftsman_attrs(attrs)
      {:name => "#{attrs[:person][:first_name]} #{attrs[:person][:last_name]}", :email => attrs[:person][:email], :employment_id => attrs[:id], :position => attrs[:position][:name]}
    end

    def warehouse_ids
      @api.current_craftsmen.collect{ |craftsman| craftsman[:id] }
    end
  end
end

