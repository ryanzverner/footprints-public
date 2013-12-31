if Rails.env == "production"
  puts "Don't run seeds in production!"
else
  require "#{Rails.root}/db/default_seeds.rb"
end
