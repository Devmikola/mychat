class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :chat
  validates :text, presence: true, allow_blank: false

  def short_text(message_length = 55)
  	result = self[:text][0, message_length]
  	self[:text].length > message_length ? "#{result}..." : result
  end

end