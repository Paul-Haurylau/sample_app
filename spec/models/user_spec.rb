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
    @attr = { name: 'Gavrilov Paul',
              email: 'gavrilov.paul@yandex.ru',
              password: 'foobar',
              password_confirmation: 'foobar'}
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

  describe 'Password validation' do
    it 'should require a password' do
      User.new(@attr.merge(password: '', password_confirmation: '')).
        should_not be_valid
    end

    it 'should require a password confirmation' do
      User.new(@attr.merge(password_confirmation: 'invalid')).
        should_not be_valid
    end

    it 'should reject short password' do
      short_password = 'a' * 4
      User.new(@attr.merge(password: short_password, password_confirmation: short_password)).
        should_not be_valid
    end

    it 'should reject long password' do
      long_password = 'a' * 50
      User.new(@attr.merge(password: long_password, password_confirmation: long_password)).
        should_not be_valid
    end

    describe 'Password encryption' do
      before (:each) do
        @user = User.create!(@attr)
      end

      it 'should have encrypted password attribute' do
        @user.respond_to?(:encrypted_password)
      end

      it 'should set the encrypted password' do
        @user.encrypted_password.should_not be_blank
      end

      describe 'Has_password? method' do
        it 'should be true if passwords match' do
          @user.has_password?(@attr[:password]).should be_true
        end

        it "should be false if passwords don't match" do
          @user.has_password?('invalid').should be_false
        end
      end

      describe "authenticate method" do
        it 'should return nil on email/password mismatch' do
          wrong_password_user = User.authenticate(@attr[:email], 'wrongpass')
          wrong_password_user.should be_nil
        end

        it 'should return nil for an email address with no user' do
          wrong_email_user = User.authenticate('foo@mail.ru', @attr[:password])
          wrong_email_user.should be_nil
        end

        it 'should return the user on email/password match' do
          matching_user = User.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end
      end
    end
  end
end
