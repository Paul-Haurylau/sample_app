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

require 'spec_helper'

describe User do
  before(:each) do
    @attr = { name: 'Gavrilov Paul', email: 'gavrilov.paul@yandex.ru' }
  end

  it 'should create a new instance given valid attributes' do
    User.create!(@attr)
  end

  it 'should require a name' do
    no_name_user = User.new(@attr.merge(name: ''))
    no_name_user.should_not be_valid
  end

  it 'should require a email' do
    no_email_user = User.new(@attr.merge(email: ''))
    no_email_user.should_not be_valid
  end

  it 'should reject long name' do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(name: long_name))
    long_name_user.should_not be_valid
  end

  it 'should accept valid email' do
    valid_emails = %w[gavrilov.paul@yandex.ru pavgavrilov@gmail.com work2010@open.by]
    valid_emails.each do |address|
      valid_email_user = User.new(@attr.merge(email: address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email' do
    invalid_emails = %w[gavrilov.yandex.ru pavgavrilov@gmail @open.by]
    invalid_emails.each do |address|
      invalid_email_user = User.new(@attr.merge(email: address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject dublicate email' do
    User.create!(@attr)
    dublicate_email_user = User.new(@attr.merge(email: @attr[:email]))
    dublicate_email_user.should_not be_valid
  end

  it 'should reject email identical up to case' do
    User.create!(@attr)
    dublicate_email_user = User.new(@attr.merge(email: @attr[:email].upcase))
    dublicate_email_user.should_not be_valid
  end
end
