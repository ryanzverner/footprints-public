class UsersController < ApplicationController
  before_filter :authenticate, :employee?

  def show
    is_current_user do
      @user = repo.user.find(params[:id])
    end
  end

  def edit
    @user = repo.user.find(params[:id])
  end

  def update
    is_current_user do
      @user = repo.user.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to(user_path(@user), :notice => "Successfully updated profile.")
      else
        render :action => 'edit'
      end
    end
  end

  private
  def is_current_user
    if current_user.id != params[:id].to_i
      redirect_to :back
    else
      yield
    end
  end

  def user_params
    params.require(:user).permit(:email, :login)
  end
end
