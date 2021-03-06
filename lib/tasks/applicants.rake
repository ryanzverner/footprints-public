require './lib/highrise/highrise_puller_interactor'
require './lib/repository'
require './lib/reminder/reminder'

namespace :db do
  desc "Destroys all Applicant Records for Staging"
  task :destroy_applicants => :environment do
    puts "Destroying Applicants from Database"
    Footprints::Repository.applicant.destroy_all
  end

  desc "Pulls Applicants From 1 month ago Creates if Not Already Created"
  task :create_unadded_applicants => :environment do
    puts "Creating Applicants from Highrise If They Don't Exist"
    interactor = Interactor::HighrisePuller.new
    interactor.create_applicants_from_highrise
  end

  # For Cron Task to Pull Applicants Every 4 Hours
  desc "Pulls New Applicants From Highrise"
  task :get_new_applicants => :environment do
    puts "Getting new applicants"
    interactor = Interactor::HighrisePuller.new
    interactor.sync_unadded_applicants
  end
end

namespace :reminder do
  desc "Sends email reminder if outstanding applicant request"
  task :outstanding_applicant => :environment do
    puts "Sending email for outstanding applicant"
    Footprints::Reminder.notify_crafter_of_outstanding_requests
  end
end

namespace :convert do
  desc "Converts outdated crafter_ids to current crafter_ids"
  task :applicant_crafter_ids => :environment do
    puts "Convert crafter_ids to new crafter records"
    Applicant.all.each do |applicant|
      crafter = Crafter.find_by_name(applicant.assigned_crafter)
      applicant.crafter_id = crafter.id rescue nil
      applicant.save
    end
  end

  desc "Converts crafter_notification_time into Notification"
  task :notifications => :environment do
    Applicant.all.each do |applicant|
      if applicant.crafter
        crafter_id = applicant.crafter.id
        notification_time = applicant.crafter_notification_time
        Notification.create(:applicant_id => applicant.id, :crafter_id => crafter_id,
                            :created_at => notification_time)
        if applicant.outstanding?(2)
          steward_id = Crafter.find_by_email(ENV["STEWARD"]).id
          Notification.create(:applicant_id => applicant.id, :crafter_id => steward_id,
                              :created_at => applicant.crafter_notification_time)
        end
      end
    end
  end
end
