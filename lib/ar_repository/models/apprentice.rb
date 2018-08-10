class Apprentice < ActiveRecord::Base
  validates :name, presence: true
  validates :email, uniqueness: true, allow_nil: true
end
