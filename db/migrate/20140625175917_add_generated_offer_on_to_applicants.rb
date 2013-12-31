class AddGeneratedOfferOnToApplicants < ActiveRecord::Migration
  def up
    add_column :applicants, :offered_on, :date
    Applicant.find_each do |applicant|
      applicant.update_attribute(:offered_on, applicant.decision_made_on)
    end
  end

  def down
    remove_column :applicants, :offered_on
  end
end
