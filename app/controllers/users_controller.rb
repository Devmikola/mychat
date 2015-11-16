class UsersController < ApplicationController
  before_action :internal_facecontroll, only: [:new, :create]

  def index
    @users = User.all
    @users = User.paginate(page: params[:page])  
  end
  
  def show
  	@user = User.find_by(id: params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def new
  	@user = User.new
  end

  def create
    # user_params[:name].downcase!
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the MyChat !"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end  
end
