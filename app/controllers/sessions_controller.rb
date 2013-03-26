class SessionsController < ApplicationController
  
  before_filter :authenticate_user, :except => [:index, :login, :login_attempt, :logout]
  before_filter :save_login_state, :only => [:index, :login, :login_attempt] 
  
  def login
    
  end
  
  def login_attempt
    
    authorized_user = User.authenticate(params[:username_or_email], params[:login_password])
    
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Welcome back, #{authorized_user.username}"
      redirect_to(:action => 'home')
    else
      flash[:notice] = "Invalid username or password."
      flash[:color] = "invalid"
      render "login"
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out!"
    redirect_to :action => 'login'
  end

  def home    
    
    if !board.nil?
       board.enableServo
    end
    
    @pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    if @pid_exists
      @status = "Motion exists."
      @button_label = "Close Motion"
    else
      @status = "Motion is not running."
      @button_label = "Open Motion"
    end
    
    respond_to do |format|
      format.html
      format.js
    end
    
  end

  def setting
  end

end