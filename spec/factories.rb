FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
		password "foobar"
		password_confirmation "foobar"

	end

	factory :chat do
		sequence(:name)  { |n| "Chat #{n}" }
	end
end