class RenameApplicantTttRepoLinkToCodeSubmission < ActiveRecord::Migration
  def change
    rename_column :applicants, :ttt_repo_link, :code_submission
    rename_column :applicants, :completed_ttt_on, :completed_challenge_on
    rename_column :applicants, :resubmitted_ttt_on, :resubmitted_challenge_on
  end
end
