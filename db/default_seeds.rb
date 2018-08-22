# encoding: utf-8

require 'applicant_dispatch/strategies/default_all_design_applicants'
require 'applicant_dispatch/strategies/default_all_london_applicants'
require 'applicant_dispatch/strategies/default_all_los_angeles_applicants'

module DefaultSeed
  class << self
    def apprentice
      Apprentice.destroy_all
      puts "------------------------------------------------------------"
      puts "---------------------Adding Apprentices----------------------"
      
      [
        "Eric Jolphy",
        "Charlie Jarker",
        "Paul Jesmond",
        "John Joltrane",
        "Wayne Jhorter",
        "Stan Jetz",
        "Bill Jevans",
        "Herbie Jancock",
        "Oscar Jeterson",
        "Clifford Jrown",
        "Miles Javis",
        "Booker Jittle",
        "Art Jlakey",
        "Max Joach",
        "Buddy Jich",
        "Charles Jingus",
        "Ron Jarter",
        "Paul Jhambers",
        "JJ Yohnson",
        "Jaco Jastorius",
        "Dave Jrubeck",
        "Ryan Jerner Sr.",
        "Ryan Jerner Jr.",
        "Ryan Jerner"
      ].each do |apprentice|
        start_date = Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}")
        Footprints::Repository.apprentice.create({
          :name => apprentice,
          :email => "#{apprentice.downcase.gsub(" ", ".")}@abcinc.com",
          :position => ["developer", "designer"].sample,
          :location => ["Chicago", "London", "Los Angeles"].sample,
          :hired => "yes",
          :applied_on => (1..365).to_a.sample.days.ago,
          :start_date => start_date,
          :end_date => (start_date + 3.month)
          })
        puts "New apprentice #{apprentice} added to the #{Rails.env} environment"
      end
      puts "------------------------------------------------------------"
      
    end
    
    def applicant
      Applicant.destroy_all
      puts "------------------------------------------------------------"
      puts "---------------------Adding Applicants----------------------"
      
      [
        "Eric Dolphy",
        "Charlie Parker",
        "Paul Desmond",
        "John Coltrane",
        "Wayne Shorter",
        "Stan Getz",
        "Bill Evans",
        "Herbie Hancock",
        "Oscar Peterson",
        "Clifford Brown",
        "Miles Davis",
        "Booker Little",
        "Art Blakey",
        "Max Roach",
        "Buddy Rich",
        "Charles Mingus",
        "Ron Carter",
        "Paul Chambers",
        "JJ Johnson",
        "Jaco Pastorius",
        "Dave Brubeck",
        "Brian Blade",
        "Roy Hargrove",
        "Michael Brecker"
      ].each do |applicant|
        Footprints::Repository.applicant.create({
          :name => applicant,
          :email => "#{applicant.downcase.gsub(" ", ".")}@gmail.com",
          :skill => ["craftsman", "student", "resident"].sample,
          :discipline => ["developer", "designer"].sample,
          :location => ["Chicago", "London", "Los Angeles"].sample,
          :applied_on => (1..365).to_a.sample.days.ago,
          :about => "My story is long and fascinating. Lorem ipsum dolor sit amet...",
          :software_interest => "Software is amazing! Lorem ipsum dolor sit amet...",
          :reason => "Lorem ipsum dolor sit amet..."})
        puts "New applicant #{applicant} added to the #{Rails.env} environment"
      end
      puts "------------------------------------------------------------"

    end

    def add_interaction_dates
      puts "------------------------------------------------------------"
      puts "-----------------Adding Interaction Dates-------------------"

      all_applicants = Footprints::Repository.applicant.all
      count = Footprints::Repository.applicant.all.count

      all_applicants.first(count - 3).each do |applicant|
        applicant.initial_reply_on = Date.current - 2.months - 3.weeks
        applicant.save
        puts "Replied to #{applicant.name} on #{applicant.initial_reply_on}."
      end

      all_applicants.first(count - 6).each do |applicant|
        applicant.sent_challenge_on = Date.current - 2.months - 2.weeks
        applicant.save
        puts "Sent challenge to #{applicant.name} on #{applicant.sent_challenge_on}."
      end

      all_applicants.first(count - 9).each do |applicant|
        applicant.completed_challenge_on = Date.current - 2.months
        applicant.save
        puts "#{applicant.name} completed challenge on #{applicant.completed_challenge_on}."
      end

      all_applicants.first(count - 12).each do |applicant|
        applicant.reviewed_on = Date.current - 1.month
        applicant.save
        puts "Reviewed #{applicant.name} on #{applicant.reviewed_on}."
      end

      all_applicants.first(count - 15).each do |applicant|
        applicant.start_date = Date.current + 1.week
        applicant.end_date = Date.current + 6.months
        applicant.offered_on = Date.current - 3.weeks
        applicant.save
        puts "Extended offer to #{applicant.name} on #{applicant.offered_on}."
      end

      all_applicants.first(count - 18).each do |applicant|
        applicant.decision_made_on = Date.current - 2.weeks
        applicant.hired = "yes"
        applicant.archived = true
        applicant.save
        puts "Hired #{applicant.name} on #{applicant.decision_made_on}."
      end

      all_applicants.last(3).each do |applicant|
        applicant.hired = "no"
        applicant.archived = true
        applicant.save
        puts "Declined #{applicant.name}."
      end

      puts "------------------------------------------------------------"
      puts "---------------Adding Unassigned Applicants-----------------"

      [
        "Pigchaser Waterman",
        "Barnfarmer Davison",
        "Pickuppusher Virgo",
        "Wheathauler Neville",
        "Haygreaser McAdams",
        "Hogpusher Ó Mathghamhna",
        "Hicksower Waldroup",
        "Shotgungreaser Faulkner",
        "Cowfarmer Abramson",
        "Cornhauler Ericson",
        "Cowtoter Ainsley",
        "Septima Bandyopadhyay",
        "Elektra Avninder",
        "Albertus Gouveia",
        "Bernt Graner",
        "Ara Averill",
        "Jaroslav Tobias",
        "Radovan MacFarlane",
        "Alkyone Abel",
        "Billy Bob",
        "Astraldream Spacedaddy",
        "Jaroslav Schwarz",
        "Sinéad Yancy",
        "Amyas De Leon",
        "Glykeria Armati",
        "Iunia Purcell",
        "Gilah Appeldoorn",
        "Leopoldo Janzen",
        "Dominik Vroomen",
        "Tânia Adenauer"
      ].shuffle.each do |unassigned|
        puts "New unassigned applicant #{unassigned} added to the #{Rails.env} environment"

        Footprints::Repository.applicant.create({
          :name => unassigned,
          :email => "#{unassigned.downcase.gsub(" ", ".")}@gmail.com",
          :skill => ["student", "resident"].sample,
          :discipline => ["developer", "developer", "developer", "developer", "developer", "designer"].sample,
          :location => ["Chicago", "Chicago", "Chicago", "Chicago", "Chicago", "London", "Los Angeles"].sample,
          :applied_on => (1..365).to_a.sample.days.ago,
          :about => "My story is long and fascinating. Lorem ipsum dolor sit amet...",
          :software_interest => "Software is amazing! Lorem ipsum dolor sit amet...",
          :reason => "Lorem ipsum dolor sit amet..."})
      end

      puts "------------------------------------------------------------"
    end

    def craftsman
      Craftsman.destroy_all
      puts "------------------------------------------------------------"
      puts "----------------------Adding Craftsmen----------------------"

      [
        "Tom Johannsen",
        "Douglas Kles",
        "Alan Abernathy",
        "Julia Thompson",
        "Robert Banks",
        "Charlie Batch",
        "Daniel Booth",
        "Albert Carter",
        "Rebecca Kirkland",
        "Carol Buffett",
        "Jimmy Watkins",
        "Bruce Chatwin",
        "Ray Smith",
        "Joseph Conrad",
        "Bryan Cooper",
        "Dennis Drake",
        "Peter Dillard",
        "Helen Garfield",
        "Colin Gonil",
      ].each_with_index do |name, i|
        Footprints::Repository.craftsman.create({
          :name           => name,
          :location       => "Chicago",
          :employment_id  => i,
          :email          => "#{name.downcase.gsub(' ', '.')}@abcinc.com",
          :start_date     => Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}"),
          :end_date       => nil,
          :seeking        => true,
          :has_apprentice => [true, false].sample,
          :skill          => [1, 2].sample
        })

        puts "#{name} added to the #{Rails.env} environment"
      end

      new_craftsman = Footprints::Repository.craftsman.create({
        :name           => "Russell Baker (London Director)",
        :location       => "London",
        :employment_id  => 103,
        :email          => ApplicantDispatch::Strategies::DefaultAllLondonApplicants::LONDON_DIRECTOR_EMAIL,
        :seeking        => true,
        :start_date     => Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}"),
        :has_apprentice => [true, false].sample,
        :skill          => [1, 2].sample})

      puts "#{new_craftsman.name} added to the #{Rails.env} environment"

      new_craftsman = Footprints::Repository.craftsman.create({
        :name           => "Clare Heyward (Los Angeles Director)",
        :location       => "Los Angeles",
        :employment_id  => 104,
        :email          => ApplicantDispatch::Strategies::DefaultAllLosAngelesApplicants::LOS_ANGELES_DIRECTOR_EMAIL,
        :seeking        => true,
        :start_date     => Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}"),
        :has_apprentice => [true, false].sample,
        :skill          => [1, 2].sample})

      puts "#{new_craftsman.name} added to the #{Rails.env} environment"

      new_craftsman = Footprints::Repository.craftsman.create({
        :name           => "Paul Goldman (Lead Designer)",
        :location       => "Chicago",
        :employment_id  => 105,
        :email          => ApplicantDispatch::Strategies::DefaultAllDesignApplicants::LEAD_DESIGNER_EMAIL,
        :seeking        => true,
        :start_date     => Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}"),
        :has_apprentice => [true, false].sample,
        :skill          => [1, 2].sample})

      puts "#{new_craftsman.name} added to the #{Rails.env} environment"

      new_craftsman = Footprints::Repository.craftsman.create({
        :name           => "Graham Hain (Steward)",
        :location       => "Chicago",
        :employment_id  => 100,
        :email          => ENV['STEWARD'],
        :seeking        => true,
        :start_date     => Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}"),
        :has_apprentice => [true, false].sample,
        :skill          => [1, 2].sample})

      puts "#{new_craftsman.name} added to the #{Rails.env} environment"

      new_craftsman = Footprints::Repository.craftsman.create({
        :name           => "Natalie Snow",
        :location       => "Chicago",
        :employment_id  => 102,
        :email          => "you@abcinc.com",
        :seeking        => true,
        :start_date     => Date.parse("2018-#{(1..12).to_a.sample}-#{(1..28).to_a.sample}"),
        :has_apprentice => [true, false].sample,
        :skill          => [1, 2].sample})
      puts "#{new_craftsman.name} added to the #{Rails.env} environment"

      puts "------------------------------------------------------------"
    end

    def user
      User.destroy_all
      puts "------------------------------------------------------------"
      puts "-----------------------Adding Users-------------------------"

      new_user = Footprints::Repository.user.create({
        :email => ENV['STEWARD']
      })

      puts "New User LINKED TO #{new_user.craftsman.name} FROM CALLBACK"

      new_user = Footprints::Repository.user.create({
        :email => "b.craftsman@gmail.com"
      })

      puts "new user added to the #{Rails.env} environment"

      new_user = Footprints::Repository.user.create({
        :login => "you@abcinc.com",
        :uid   => "107478018817920458918",
        :provider => "google_oauth2",
        :email => "you@abcinc.com",
        :admin => true
      })

      puts "new user added to the #{Rails.env} environment"

      puts "------------------------------------------------------------"
    end

    def assign_craftsmen
      puts "------------------------------------------------------------"
      puts "--------------------Assigning Craftsmen---------------------"

      Footprints::Repository.applicant.all.each do |applicant|
        craftsman_ids = Footprints::Repository.craftsman.all.pluck(:employment_id)
        craftsman_id = craftsman_ids.sample
        craftsman = Footprints::Repository.craftsman.find(craftsman_id)
        applicant.assigned_craftsman = craftsman.name
        applicant.craftsman_id = craftsman.employment_id
        applicant.save
        puts "#{craftsman.name} has been assigned to #{applicant.name}"
      end

      puts "------------------------------------------------------------"
    end

    def add_salaries
      MonthlyApprenticeSalary.destroy_all
      AnnualStartingCraftsmanSalary.destroy_all
      puts "------------------------------------------------------------"
      puts "---------------------Adding Salaries------------------------"

      (3..12).each do |months|
        chicago_monthly = Footprints::Repository.monthly_apprentice_salary.create({:location => "Chicago",
                                                                                   :duration => months,
                                                                                   :amount => months * 100})
        puts "Added monthly apprentice salary for #{chicago_monthly.duration} months in #{chicago_monthly.location}: #{chicago_monthly.amount}"
        london_monthly = Footprints::Repository.monthly_apprentice_salary.create({:location => "London",
                                                                                  :duration => months,
                                                                                  :amount => months * 200})
        puts "Added monthly apprentice salary for #{london_monthly.duration} months in #{london_monthly.location}: #{london_monthly.amount}"
        los_angeles_monthly = Footprints::Repository.monthly_apprentice_salary.create({:location => "Los Angeles",
                                                                                  :duration => months,
                                                                                  :amount => months * 100})
        puts "Added monthly apprentice salary for #{los_angeles_monthly.duration} months in #{los_angeles_monthly.location}: #{los_angeles_monthly.amount}"
      end

      chicago_annual_salary = Footprints::Repository.annual_starting_craftsman_salary.create({:location => "Chicago",
                                                                                              :amount => 100000})
      puts "Added annual starting craftsman salary for #{chicago_annual_salary.location}: #{chicago_annual_salary.amount}"

      london_annual_salary = Footprints::Repository.annual_starting_craftsman_salary.create({:location => "London",
                                                                                             :amount => 200000})
      puts "Added annual starting craftsman salary for #{london_annual_salary.location}: #{london_annual_salary.amount}"

      los_angeles_annual_salary = Footprints::Repository.annual_starting_craftsman_salary.create({:location => "Los Angeles",
                                                                                             :amount => 200000})
      puts "Added annual starting craftsman salary for #{los_angeles_annual_salary.location}: #{los_angeles_annual_salary.amount}"
      puts "------------------------------------------------------------"
    end

    def staging_steward
      Craftsman.find_by_email(ENV["STEWARD"]).try(:destroy)
      Craftsman.create_footprints_steward(999)
    end
  end
end


if Rails.env == "development"
  DefaultSeed.craftsman
  DefaultSeed.user
elsif Rails.env == "staging"
  DefaultSeed.staging_steward
end

DefaultSeed.apprentice
DefaultSeed.applicant
DefaultSeed.assign_craftsmen
DefaultSeed.add_interaction_dates
DefaultSeed.add_salaries
