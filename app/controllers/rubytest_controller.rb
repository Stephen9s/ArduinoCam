class RubytestController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
        
  end
  
  def left
    board.rotateLeft    
    
    respond_to do | format |
        format.html   { redirect_to index_path }
        format.js { }
      end
  end
  
  def right
    board.rotateRight
    
    respond_to do | format |
        format.html   { redirect_to index_path }
        format.js {  }
      end
  end
  
  def close
    if !board.nil?
      # Explicitly disable the servo
      #board.disableServo
      
      # Then close the board
      board.close
    end
    
    respond_to do | format |
        format.html   { redirect_to index_path }
        format.js {  }
      end
  end
 
  
  def refreshSnapshot
    image = Snapshot.last
    @snapshot = image.filename
    @snapshot.slice! "/var/www/test/app/assets/images/snapshots/"
    render :partial => "rubytest/refreshSnapshot"
  end
  
  def closeCamera
    # Initial check for motion.pid file
    pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    if pid_exists
      # If PID file exists, destroy process first so that it has a graceful quit
      destroy_process = system("kill $(pidof motion)")
      
      # Check again if the motion.pid exists
      # If it does, then process wasn't killed gracefully
      pid_still_exists = File.exist?("/var/www/test/pid/motion.pid")
      
      if pid_still_exists
        # Remove the file if it exists
        remove_pid_forcefully = File.delete("/var/www/test/pid/motion.pid")
        
        if remove_pid_forcefully
          @status = "PID file removed forcefully."
          @button_label = "Start Motion"  
        end
        
      else
        
        @status = "Motion gracefully destroyed."
        @button_label = "Start Motion"
        
      end
      
    end
    
    respond_to do | format |
        format.html
        format.js
    end
    
  end
  
  def startCamera
    # Initial check for motion.pid file
    pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    # Ensure that motion is NOT running
    if !pid_exists
      
      start = system("/usr/local/bin/motion -m")
      
      @pid_now_exists = File.exist?("/var/www/test/pid/motion.pid")
      
      if @pid_now_exists
        @status = "Static Camera Started."
        @button_label = "Close Motion."
      else
        @status = "Motion failed to start."
        @button_label = "Start Motion"
      end
      
    else
      @status = "Motion is already running."
      @button_label = "Close Motion"
    end
    
    respond_to do | format |
        format.html
        format.js
    end
    
  end
  
end
