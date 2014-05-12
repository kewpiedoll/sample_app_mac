require 'spec_helper'

describe User do

  before do 
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobarbazbat",
                     password_confirmation: "foobarbazbat", system: 1, init_reading: 1890)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:system) }
  it { should respond_to(:init_reading) }

  it { should be_valid }

  describe "when name is not present" do 
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do 
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # I wrote these specs -- anything for "system" and "init-reading" is not included
  # in the text examples
  describe "when system is not present" do 
    before { @user.system = " " }
    it { should_not be_valid }
  end

  describe "when init_reading is not present" do 
    before { @user.init_reading = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do 
    before { @user.name = "a" * 26}
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do 
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar_baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is invalid" do
    it "should be invalid" do 
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do 
    before do 
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  # Kewpiedoll specific tests for system/init_reading below
  describe "when system value is not within range" do
    it "should be invalid" do 
      system_values = [1000, -20, 7, 0]
      system_values.each do |invalid_value|
        @user.system = invalid_value 
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when initial meter reading is not a reasonable, positive number, or 0" do 
    it "should not be invalid" do 
      system_values = [-1, 1000000001]
      system_values.each do |invalid_value|
        @user.init_reading = invalid_value 
        expect(@user).not_to be_valid
      end
    end
  end
  # end Kewpiedoll specific tests

  describe "when password is not present" do 
    before do 
      @user = User.new(name: "Example User", email: "user@example.com", password: " ",
                       password_confirmation: " ", system: 1, init_reading: 1890)
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do 
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do 
    before { @user.password = @user.password_confirmation = "a" * 9 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do 
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do 
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end



end









#


