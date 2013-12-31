require './lib/repository'
class Message < ActiveRecord::Base
  belongs_to :applicant 
end
