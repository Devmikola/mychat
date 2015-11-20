
require 'spec_helper'

describe "Chats" do
	subject { page }
	  

	let(:user) { FactoryGirl.create(:user) }
	let(:first_member) { FactoryGirl.create(:user) }	
	let(:second_member) { FactoryGirl.create(:user) }	

	before do
	  visit signin_path
	  fill_in "Name",    with: user.name
	  fill_in "Password", with: user.password
	  click_button "Sign in"
	end

	
	describe "creation page" do
		before { visit new_chat_path }

		it { should have_content('Create chat')}
		it { should have_title('Create chat')}

		describe "send empty form" do
			before { click_button "Create chat"}

			it { should have_content('Create chat') }
			it { should have_selector('div.alert.alert-error') }

		    describe "after visiting another page" do
		      before { click_link "Home" }
		      it { should_not have_selector('div.alert.alert-error') }
		    end  			
		end

		describe "send form with invalid data" do
			before do
			  fill_in "Name",    with: "Test_Chat"
			  fill_in "Members", with: "1000 14123"
			  click_button "Create chat"
			end			

			it { should have_content('Members can not contain users which not exist: 1000 14123') }
		end

		describe "send form with correct data" do
			before do
			  fill_in "Name",    with: "Test_Chat"
			  fill_in "Members", with: [first_member.id, second_member.id].join(" ")
			  click_button "Create chat"
			end							

		  let(:members_list) { [user.name_cptlz, first_member.name_cptlz, second_member.name_cptlz].join(", ") }

			it { should have_content("Members of chat: #{members_list}") }

			
			describe "changes at show page" do
				before do
					fill_in "message_text", with: "First message"
					# click_button "Send message"
				end

        		it "create message" do
        			expect { click_button "Send message" }.to change(Message, :count).by(1)
        		end

        		describe "message incoming at index page" do
    				let(:chat) { Chat.find_by name: "Test_Chat" }

        			before do 
        				Message.new(chat_id: chat.id, user_id: user.id, text: "Second Message").save
        				visit chats_path 
        			end
        			
					# find('#item_description').should have_content("laptop for 369")
        			it { find('.tr_link#' + chat.id.to_s, text: "Second Message", exact: true) }
        			it { find('.tr_link#' + chat.id.to_s, text: "0", exact: true) }
        			it { find('.tr_link#' + chat.id.to_s, text: user.name_cptlz, exact: true) }

        		end

			end

			describe "created chat without messages at index page" do
				before { click_link "Chats" }
				
				it { should have_content('Test_Chat') }
				it { should have_content('No messages yet') }


			end


		end
	end	
end