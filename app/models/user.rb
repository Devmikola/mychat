class User < ActiveRecord::Base
  before_save { self.name = name.downcase }
  before_create :create_remember_token

  validates :name, presence: true, length: {maximum: 20}, uniqueness: true
  validates :password, length: { minimum: 6 }
  
  has_many :chats, class_name: "Chatuser" 
  has_many :full_chats, through: :chats, class_name: "Chat"

  has_many :messages
  has_many :chat_by_message, through: :messages, class_name: "Chat"

  has_many :owning_chats, foreign_key: :user_id, class_name: "Chat"

  before_validation { name_downcase }

  has_secure_password

  scope :at_users,  ->(user_ids) { where("id in (?)", user_ids)}
  scope :online, -> { where("last_seen between :start_dttm and :end_dttm", {start_dttm: DateTime.now - 1.minute, end_dttm: DateTime.now} ) }

  def name_cptlz
    self[:name].capitalize
  end

  def online?
    self.last_seen && Time.now - self.last_seen < 60 ? true : false
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def name_downcase
      name.downcase!
    end
end