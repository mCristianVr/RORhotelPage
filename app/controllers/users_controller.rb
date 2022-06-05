class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show]

  def index
    if params[ :search ]
      search_user
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the app!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.present?
      @user.destroy

      respond_to do |format|
        format.html { redirect_to users_url, notice: "El usuario se ha eliminado." }
        format.json { head :no_content }
      end
    end

  end

  def make_reception()
    @user = User.find(params[:id])
    if @user.present?
      @user.update_attribute(:roles_id, Role.find_by(role: "reception")._id)

      respond_to do |format|
        format.html { redirect_to users_url, notice: "El usuario se ha actualizado." }
        format.json { head :no_content }
      end
    end
  end

  def make_admin()
    @user = User.find(params[:id])
    if @user.present?
      @user.update_attribute(:roles_id, Role.find_by(role: "admin")._id)

      respond_to do |format|
        format.html { redirect_to users_url, notice: "El usuario se ha actualizado." }
        format.json { head :no_content }
      end
    end
  end


  private

  def user_params
    params.require(:user).permit( :name, :email, :password, :password_confirmation, :roles )
  end

  def search_user
    @user = User.all.find{|user| user.email.include?(params[:search])}
    if @user.present?
      redirect_to user_path(@user)

    else
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'El usuario no existe' }
        format.json { head :no_content }
      end
    end
  end

end
