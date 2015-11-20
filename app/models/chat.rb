class Chat < ActiveRecord::Base
    has_many :chatusers, dependent: :destroy
    belongs_to :owner, foreign_key: :user_id, class_name: 'User'
    has_many :messages, dependent: :destroy

    validates :name, presence: true, length: {maximum: 40}, uniqueness: { case_sensitive: false }

    after_validation { set_members }

    def owner?(user)
      self.user_id == user.id
    end

    def members=(members)
        @members = members
    end

    def members
      @members = chatusers.map { |chat_user| chat_user.user_id }.join(' ')
    end

    def members_transform(members, creator_id)

      @members = members.split(' ').collect { |x| x.to_i }
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
      @members_names ||= get_members
    end

    def get_members
      chatusers.inject(Array.new) do |list_names, chat_user|
        list_names.push chat_user.user.name.capitalize
      end
    end

  	private

	  	def set_members

	  		unless @unexists_users.empty?
	  			errors.add(:members, 'can not contain users which not exist: ' + @unexists_users.join(' ') )
	  		end
    		
	  		unless @chat_users.count >= 2
  				errors.add(:members, 'need contain at least 2 users')
  			end

    		Rails.logger.debug '@MEMBERS:' + @members.inspect
    		Rails.logger.debug '@CHATUSERS:' + @chat_users.inspect
	  		

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