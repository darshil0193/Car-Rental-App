class UsersController < ApplicationController
  def index
    @users = User.where(admin: false, superadmin: false)
    @admins = User.where(admin: true)
    @superadmins = User.where(superadmin: true)
  end

  def new
  end

  def show
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_index_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
