class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @books = @user.books
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "Profile was successfully updated"
      redirect_to user_path(@user.id)
    else
      flash[:alert] = "error:Profile failed to be updated"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

end