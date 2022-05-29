class PasswordsController < ApplicationController
 
  before_action :logged_in_user

  def edit

  end

  def update
    if current_user.update( password_params )
	redirect_to user_path(:id => session[:user_id]), notice: "Contraseña actualizada."
    else
	render :edit
    end
  end

  private
  
  def password_params
    params.require( :user ).permit( :password, :password_confirmation )
  end

end
