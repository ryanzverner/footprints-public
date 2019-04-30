class Notification < ActiveRecord::Base

  belongs_to :applicant
  belongs_to :crafter

end
