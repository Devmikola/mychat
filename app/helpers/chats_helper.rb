module ChatsHelper
  def members_list(chat_id)
    Chat.find(chat_id).chatusers.includes(:user).collect do |member|
      {id: member.user_id, name: member.user.name_cptlz, is_online: member.user.online?}
    end
  end
end
