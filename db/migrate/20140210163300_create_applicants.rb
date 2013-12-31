class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :name
      t.date :applied_on
      t.string :email
      t.date :initial_reply_on
      t.date :completed_ttt_on
      t.date :reviewed_on
      t.date :begin_refactoring_on
      t.date :resubmitted_ttt_on
      t.date :decision_made_on
      t.boolean :hired
      t.string :codeschool
      t.string :college_degree
      t.string :cs_degree
      t.string :worked_as_dev
      t.string :assigned_craftsman
      t.string :ttt_repo_link
      t.string :state
      t.text :additional_notes
    end
  end
end
