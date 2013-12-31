module Warehouse
  module SpecHelpers
    def self.create_employment(params)
      {
        id:    params.fetch(:id),
        start: params.fetch(:start),
        end:   params[:end],
        person: {
          id: params[:p_id],
          first_name: params.fetch(:first_name),
          last_name:  params.fetch(:last_name),
          email:      params.fetch(:email)
        },
        position_id: 1,
        position: {
          :id => 1,
          :name => params.fetch(:position_name)
        }
      }
    end
  end
end
