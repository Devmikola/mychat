module SessionsHelper
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    #user.remember_token = User.encrypt(remember_token)
    #user.last_seen = Time.now
    #user.save
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    user.update_attribute(:last_seen, DateTime.now)
    #user.assign_attributes(remember_token: User.encrypt(remember_token), last_seen: Time.now)
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def mobile?
    request.user_agent =~ /Mobile|webOS/
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(remember_token: User.encrypt(cookies[:remember_token]))

    if !@current_user.nil? && !@current_user.last_seen.nil? && Time.now - @current_user.last_seen > 59.seconds
      @current_user.update_attribute :last_seen, Time.now()
    end

    @current_user
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def internal_facecontrol
    redirect_to root_url if signed_in?
  end

  def facecontrol
    redirect_to signin_path if !signed_in?
  end
end
