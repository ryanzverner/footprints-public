require './lib/repository'

class User < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :crafter
  before_create :associate_crafter

  def associate_crafter
    crafter = Crafter.find_by_email(self.email)
    self.crafter_id = crafter.employment_id if crafter
  end

  private

  def self.find_or_create_by_auth_hash(hash)
    if user = User.find_by_uid(hash['uid'])
      return user
    end

    user = User.new
    user.email = user.login = hash['info']['email']
    user.uid = hash['uid']
    user.provider = hash['provider']
    user.save!
    user
  end
end
