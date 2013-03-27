class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :board
  
  def board
    # /dev/ttyACM0/1/2/3 etc are files, so File.exist?() can be used
    port = ['/dev/ttyACM0', '/dev/ttyACM1', '/dev/ttyACM2']
    
    port_exists = false
    port_available = nil
    @board = nil
    
    port.each do |p|
      port_exists = File.exist?(p)
      if port_exists
        port_available = p
        break
      end
      
    end
       
    if port_exists
      begin
        #specify the port as an argument
        @board = Arduino.new(port_available)
      rescue
        # Do nothing
      end
    end
    
  end
  
   protected
    
    def authenticate_user
      unless session[:user_id]
        redirect_to(:controller => 'sessions', :action => 'login')
        return false
      else
        begin
          @current_user = User.find(session[:user_id])

          return true
        rescue ActiveRecord::RecordNotFound
          redirect_to(:controller => 'sessions', :action => 'logout')
        end
      end
    end
    
    def save_login_state
      if session[:user_id]
        redirect_to(:controller => 'sessions', :action => 'home')
        return false
      else
        return true
      end
    end
    
    private
    
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    helper_method :current_user
    
end
