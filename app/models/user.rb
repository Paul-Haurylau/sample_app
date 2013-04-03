# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, length: { maximum: 50 }, presence: true
  validates :email, format: { with: email_regex }, uniqueness: { case_sensitive: false},  presence: true
  validates :password, confirmation: true, length: { within: 6..40 }, presence: true

  before_save :encrypt_password

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user :nil
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def make_salt
    secure_hash("#{Time.now.utc}")
    #secure_hash("#{Time.now.utc}--#{password}")
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end

