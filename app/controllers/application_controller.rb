class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :board  
  
  # Method used with before_filter on all controllers that calls prepare_for_mobile if the device is mobile
  # If mobile, prepend the view path with "views_mobile" instead of "views"
  # Sources:  http://railscasts.com/episodes/199-mobile-devices
  # =>        http://scottwb.com/blog/2012/02/23/a-better-way-to-add-mobile-pages-to-a-rails-site/
  def check_for_mobile
    session[:enable_mobile] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end
  
  # Method called to determine if Arduino is attached by searching one of three ttyACX files  
  def board
    
    # /dev/ttyACM0/1/2/3 etc are files, so File.exist?() can be used
    port = ['/dev/ttyACM0', '/dev/ttyACM1', '/dev/ttyACM2']
    
    # Assume that the port doesn't exist and instantiate variable to reference the port that does exist; also instantiate board variable to nil as well.
    port_exists = false
    port_available = nil
    @board = nil
    
    # For each port, use the Ruby File class to detect if /dev/ttyACX exists
    # If it exists, save reference to element with the string.
    port.each do |p|
      port_exists = File.exist?(p)
      if port_exists
        port_available = p
        
        # Break out of loop immediately after finding the Arduino
        break
      end      
    end
       
    # If Arduino exists, use the Arduino class and connect to it.
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
  
    helper_method :mobile_device?
    helper_method :current_user
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    
    # Method used to detect if the viewer is on a mobile device
    def mobile_device?
      if session[:enable_mobile]
        session[:enable_mobile] == "1"
      else
        request.user_agent =~ /Mobile|iPhone/
      end
    end
    
    # Method changes the prepend view path based on viewer's device
    def prepare_for_mobile
      prepend_view_path Rails.root + 'app' + 'views_mobile'
    end
    
end
