require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :uniqueness => true
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }
                       
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password) 
    user = find_by_email(email) 
    return nil if user.nil? 
    return user if user.has_password?(submitted_password)
  end
  
  private
  def encrypt_password
    self.salt = make_salt if new_record? #Remove this to introduce a bug where modifying user changes their password - good idea?
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string) 
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt 
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string) 
    Digest::SHA2.hexdigest(string)
  end
end
