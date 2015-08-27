require 'spec_helper'

describe User do

	before { @user = User.new(name: "Example User", password: "123456",
		 			password_confirmation: "123456") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
  	it { should respond_to(:authenticate) }	

	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = "" }
		it {should_not be_valid}
	end

	describe "when name has already exist" do
	  	before do
	  		@new_user = @user.dup
	  		@new_user.save
	  	end

	  	it {should_not be_valid}
	end

	describe "when password is not presented" do
		before { @user.password_confirmation = "mismatch"}
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
	    before { @user.password = @user.password_confirmation = "a" * 5 }
	    it { should be_invalid }
    end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch"}
		it { should_not be_valid }		
	end

	describe "authentication results" do
		before { @user.save }
		let(:signing_user) { User.find_by(name: @user.name) }

		describe "with valid password" do
			it { should eq signing_user.authenticate(@user.password)}
		end

		describe "with not valid password" do
		    let(:user_for_invalid_password) { signing_user.authenticate("invalid") }

		    it { should_not eq user_for_invalid_password }
		    specify { expect(user_for_invalid_password).to be_falsey }			
		end
	end

end