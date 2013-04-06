class RubytestController < ApplicationController
  
  before_filter :authenticate_user
  before_filter :check_for_mobile
  
  def left
    board.rotateLeft    
    
    message = ["message" => "Turning left."]
    
    if mobile_device?
      respond_to do | format |
        format.json { render :json => message }
      end
    else      
      respond_to do | format |
        format.html
        format.js {  }
      end
    end
    
  end
  
  def right
    board.rotateRight
    
    message = ["message" => "Turning right."]
    
    if mobile_device?
      respond_to do | format |
        format.json { render :json => message }
      end
    else      
      respond_to do | format |
        format.html
        format.js {  }
      end
    end
    
  end
  
  def close
    if !board.nil?
      # Explicitly disable the servo
      #board.disableServo
      
      # Then close the board
      board.close
      board = nil
    end
    
    message = ["message" => "Connection closed."]
    
    if mobile_device?
      respond_to do | format |
        format.json { render :json => message }
      end
    else      
      respond_to do | format |
        format.html
        format.js {  }
      end
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
      destroy_process = system("killall motion")
      #pid, stdin, stdout, stderr = Open4::popen4 "killall motion"
      # Check again if the motion.pid exists
      # If it does, then process wasn't killed gracefully
      # Potential for infinite loop here
      #while (pid_still_exists = File.exist?("/var/www/test/pid/motion.pid"))
        # Loop until PID no longer exists?
      #end
      
      sleep 3.0
      
      pid_still_exists = File.exist?("/var/www/test/pid/motion.pid")
      
      if pid_still_exists
        # Remove the file if it exists
        remove_pid_forcefully = File.delete("/var/www/test/pid/motion.pid")

        if remove_pid_forcefully
          @status = "PID file removed forcefully."
          @button_label = "Start Camera"  
        end
        
      else
        
        @status = "Motion gracefully destroyed."
        @button_label = "Start Camera"
        
      end
      
    end
    
    message = [{"status" => @status, "label" => @button_label}]
    
    if mobile_device?
      respond_to do | format |
        format.json { render :json => message }
      end
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
    
  end
  
  def startCamera
    # Initial check for motion.pid file
    pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    # Ensure that motion is NOT running
    if !pid_exists
      
      start = system("/usr/local/bin/motion")
      #pid, stdin, stdout, stderr = Open4::popen4 "/usr/local/bin/motion -m"
      
      sleep 1.1
      
      @pid_now_exists = File.exist?("/var/www/test/pid/motion.pid")
      
      if @pid_now_exists
        pid, stdin, stdout, stderr = Open4::popen4 "pidof -s /usr/local/bin/motion"
        getpid = stdout.read.strip
        @status = "Motion started: PID #{getpid}"
        @button_label = "Close Camera"
      else
        @status = "Motion failed to start."
        @button_label = "Start Camera"
      end
      
    else
      pid = Process.pid("motion")
      @status = "Motion is already running: PID #{pid}"
      @button_label = "Close Camera"
    end
    
    message = [{"status" => @status, "label" => @button_label}]
    
    if mobile_device?
      respond_to do | format |
        format.json { render :json => message }
      end
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
        
    
  end
  
end
