class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :native_language_id

  validates :native_language_id, :presence => true

  def self.migrate_all_users_without_language_to_english
    english = Language.where(:name => "English")
    if english.empty?
      english = Language.create(:name => "English")
    else
      english = english.first
    end
    
    User.all.each do |user|
      user.native_language_id = english.id if user.native_language_id.nil?
      user.save!
    end
  end
end
