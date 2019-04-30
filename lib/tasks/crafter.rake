require './lib/repository'

namespace :db do
  desc "Destroys all Crafters Records for Staging"
  task :destroy_crafters => :environment do
  end

  desc "Syncs Crafters List from Doppler"
  task :sync_crafters => :environment do
  end
end

namespace :convert do
  desc "Converts user and notes crafter_ids to use crafter's employment id as foriegn key"
  task :crafter_ids_to_employment_id => :environment do
    puts "Converting foreign keys for users and notes"
    Note.all.each do |note|
      crafter = Crafter.find_by_id(note.crafter_id)
      note.crafter_id = crafter.employment_id.to_i rescue nil
      note.save!
    end

    User.all.each do |user|
      crafter = Crafter.find_by_id(user.crafter_id)
      user.crafter_id = crafter.employment_id.to_i rescue nil
      user.save!
    end
  end
end

desc "Set default crafter profile settings"
task :set_default_crafter_profile_settings => :environment do
  puts "Setting all crafter profile records to seeking: true and skill: resident"
  Crafter.all.each do |crafter|
    crafter.seeking = true
    crafter.skill = "Resident"
    crafter.save!
  end
end
