module SessionsHelper

  def log_in(user)
    session[:user_id] = user._id.to_s
    session[:name] = user.name.capitalize
    session[:role] = Role.find_by(_id: user.roles_id).role.to_s
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(_id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.clear
    @current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end