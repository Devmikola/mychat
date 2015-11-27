module UsersHelper

  def status_icon(online)
    if online
      image_tag 'Status-user-online-icon.png', title: 'online'
    else
      image_tag 'Status-user-busy-icon.png', title: 'offline'
    end
  end
end
