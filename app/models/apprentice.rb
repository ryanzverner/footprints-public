class Apprentice < ActiveRecord::Base
	include ActiveModel::Validations
	include ApprenticesHelper
	
	validates :name, presence: true
end
