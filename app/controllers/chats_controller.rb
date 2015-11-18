class ChatsController < ApplicationController
  before_action :facecontrol
  before_action :is_member?, only: [:show, :create_message] 
  before_action :get_chat, only: [:show, :edit, :update, :destroy, :self_disconnection]
  before_action :foreign_disconnection, only: [:refresh, :reset_unread_msgs]

  def index
    @access_chats = current_user.chats
  end

  def refresh_last
    last_message = Message.where(chat_id: params[:id]).last
    if last_message && last_message.id != params[:message_id].to_i
      num_unread_msgs = Chatuser.find_by(chat_id: params[:id], user_id: current_user.id).num_unread_msgs
      respond_to do |format|
        format.json {render json: {exit: false, message_text: last_message.text, author_name: last_message.user.name,
                                   message_id: last_message.id, num_unread_msgs: num_unread_msgs }}
      end
    else
      respond_to do |format|
        format.json {render json: {exit: true}} 
      end
    end      
  end


  def show
    if Chatuser.find_by(chat_id: params[:id], user_id: current_user.id)
    	#@chat = Chat.find_by(id: params[:id])
      @num_unread_msgs = @chat.chatusers.where(user_id: current_user.id).first.num_unread_msgs.to_s
      @message = Message.new
      unless @chat
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end


  def refresh
    @messages = Message.where(chat_id: params[:id]).offset(params[:offset])
    render 'refresh', :layout => false if @messages && Chatuser.find_by(chat_id: params[:id], user_id: current_user.id)
  end

  def reset_unread_msgs
    Chatuser.find_by(chat_id: params[:id], user_id: current_user.id).update(num_unread_msgs: 0)
    respond_to do |format|
      format.json { render :json => {:response => 'Reset to zero'} }
    end
  end

  def create_message
    @message = Message.new(chat_id: params[:id], user_id: current_user.id, text: params[:message][:text])
    @message.chat.chatusers.where(user_id: current_user.id).update_all(num_unread_msgs: 0)
    @message.chat.chatusers.where("user_id != ?", current_user.id).update_all("num_unread_msgs = num_unread_msgs + 1")
    @message.save
    render nothing: true
  end

  def self_disconnection
    if @chat.chatusers.count > 2
      @chat.chatusers.find_by(user_id: current_user.id).destroy
    else
      @chat.destroy
    end
    redirect_to chats_path
  end


  def new
  	@chat = Chat.new
  end

  def create
  	@chat = Chat.new(name: params[:chat][:name], user_id: current_user.id)
  	@chat.members = params[:chat][:members]
  	@chat.members_transform(params[:chat][:members], current_user.id)
  	if @chat.save
  		redirect_to chat_path @chat
  	else
  		render 'new'
  	end

  end


  def edit
      #@chat = Chat.find_by(id: params[:id])
      redirect_to root_path if @chat.user_id != current_user.id 
  end

  def update
    #@chat = Chat.find_by(id: params[:id])
    @chat.name = params[:chat][:name]
    @chat.members = params[:chat][:members]
    @chat.members_transform(params[:chat][:members], current_user.id)
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render 'edit'
    end

  end

  def destroy
    @chat.destroy
    redirect_to chats_path
  end

  def test
    @user = User.find_by(id: 1)
    # Chat.find_by(id: 6).chatusers.build(user_id: 2).save
    # @user.chats.first.chat.messages.first.update(user_id: @user.id, text: "hello, this is my message")
    # @user.chats.first.chat.update(user_id: 3)
    @test = @user

  end

  private

    def is_member?
      redirect_to chats_path unless Chatuser.find_by(chat_id: params[:id], user_id: current_user.id)
    end

    def get_chat
      @chat = Chat.find params[:id]
      redirect_to chats_path if @chat.nil?
    end

    def foreign_disconnection
      render text: 'removed' and return unless Chat.find_by id: params[:id]
      render text: 'disconnected' and return unless Chatuser.find_by(chat_id: params[:id], user_id: current_user.id)
    end


end
