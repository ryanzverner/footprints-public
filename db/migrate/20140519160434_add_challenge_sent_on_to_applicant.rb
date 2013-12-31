class AddChallengeSentOnToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :sent_challenge_on, :date
  end
end
