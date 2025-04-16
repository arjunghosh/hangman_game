class User < ApplicationRecord
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      user.coins ||= 0
      user.opt_in_email = true if user.opt_in_email.nil?
      user.active = true
      user.save!
    end
  end
end
