require './lib/repository'

class AssignedCrafterRecord < ActiveRecord::Base
  belongs_to :crafter
  belongs_to :applicant
end
