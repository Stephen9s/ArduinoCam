class SessionsController < ApplicationController
  
  before_filter :authenticate_user, :except => [:index, :login, :login_attempt, :logout]
  before_filter :save_login_state, :only => [:index, :login, :login_attempt] 
  before_filter :check_for_mobile
  
  def login
    
  end
  
  # Method called when user attempts to login
  def login_attempt
    
    authorized_user = User.authenticate(params[:username_or_email], params[:login_password])
    
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Welcome back, #{authorized_user.username}"
      redirect_to home_path
    else
      flash[:notice] = "Invalid username or password."
      flash[:color] = "invalid"
      render 'login'
    end
    
  end
  
  # Method used remove user's session
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out!"
    redirect_to :action => 'login'
  end

  # Method rendered after user logs in
  # Automatically connects to Arduino if available, otherwise provides view with data to assist in displaying the correct output
  def home    
    
    # Uses the helper method, board, to determine if Arduino exists. If it does, connect to the Servo
    if !board.nil?
       board.enableServo
    end
    
    # Home automatically loaded after login and returning to main screen
    # If Motion is currently running, change the button that is displayed (see view code)
    @pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    if @pid_exists
      @status = "Motion is running."
      @button_label = "Close Motion"
    else
      @status = "Motion is not running."
      @button_label = "Start Motion"
    end
    
    respond_to do |format|
      format.html
      format.js
    end
    
  end
  
end