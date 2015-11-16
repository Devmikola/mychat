class Chat < ActiveRecord::Base
	has_many :chatusers
	has_many :full_chatusers, through: :chatusers, class_name: "User"

	belongs_to :owner, foreign_key: :user_id, class_name: "User"

	has_many :messages
	has_many :users, through: :messages

	validates :name, presence: true, uniqueness: { case_sensitive: false }

	after_validation { set_members }

    def members=(members)
  	   	@members = members
    end

    def members
    	@members = chatusers.map { |chat_user| chat_user.user_id }.join(" ") 
    end

  	def members_transform(members, creator_id)

	  	@members = members.split(" ").collect { |x| x.to_i }
	  	@members.delete 0

	  	@members << creator_id unless @members.include? creator_id
	  	
	  	@unexists_users = Array.new
	  	@chat_users = Array.new


	  	@members.delete_if do |member_id|

	  		if User.find_by id: member_id
	  			@chat_users << member_id
	  			false
	  		else
	  			@unexists_users << member_id
	  			true
	  		end
	  	end

	  	@chat_users.uniq!	  	
	  	@unexists_users.uniq!	  	

  	end

  	def members_names

  		members_array = Array.new

    	chatusers.each do |chat_user|
    		members_array << chat_user.user.name.capitalize
    	end

    	members_array.join(", ")

  	end


  	private

	  	def set_members

	  		unless @unexists_users.empty?
	  			errors.add(:members, 'can not contain unexists users:'  + @unexists_users.join(' ') )
	  		end
    		
	  		unless @chat_users.count >= 2
  				errors.add(:members, "need contain at least 2 users")
  			end

    		Rails.logger.debug "@MEMBERS:" + @members.inspect
    		Rails.logger.debug "@CHATUSERS:" + @chat_users.inspect
	  		

  			chatusers.each do |chat_user|

  				if !@chat_users.include?(chat_user.id) && self[:user_id] != chat_user.id
  					chat_user.destroy
  				end
  			end

  			@chat_users.each do |chat_user|
  				
  				unless Chatuser.find_by chat_id: self[:id], user_id: chat_user
  					chatusers.build user_id: chat_user, num_unread_msgs: 0
  				end
			end

	  	end
end