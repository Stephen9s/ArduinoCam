class RubytestController < ApplicationController
  
  before_filter :authenticate_user
  before_filter :check_for_mobile
  
  # Method called by either AJAX or a direct controller/method call
  # Rotates motor left and if it's a mobile device, render the JSON message (for AJAX)
  # => if desktop version, format.js is used to replace HTML within specified DOM object in the method.js.erb file
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
  
  # Method called by either AJAX or a direct controller/method call
  # Rotates motor right and if it's a mobile device, render the JSON message (for AJAX)
  # => if desktop version, format.js is used to replace HTML within specified DOM object in the method.js.erb file
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
  
  # Method called by either AJAX or a direct controller/method call
  # Closes Arduino connection and if it's a mobile device, render the JSON message (for AJAX)
  # => if desktop version, format.js is used to replace HTML within specified DOM object in the method.js.erb file
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
 
  # Method called by jQuery to refresh the snapshot on the page
  def refreshSnapshot
    image = Snapshot.last
    @snapshot = image.filename
    @snapshot.slice! "/var/www/test/app/assets/images/snapshots/"
    render :partial => "rubytest/refreshSnapshot"
  end
  
  # Method called by either AJAX or a direct controller/method call
  # If the camera is on, close it. Return JSON message if mobile.
  # => if desktop version, format.js is used to replace HTML within specified DOM object in the method.js.erb file
  def closeCamera
    # Initial check for motion.pid file
    pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    if pid_exists
      
      # If PID file exists, destroy process first so that it has a graceful quit
      destroy_process = system("killall motion")

      # Determined that Motion required < 3.0 seconds after being killed to remove the PID file that it created
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
    
    # Used solely for JSON/mobile view
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
  
  # Method called by either AJAX or a direct controller/method call
  # If the camera is off, start it. Return JSON message if mobile.
  # => if desktop version, format.js is used to replace HTML within specified DOM object in the method.js.erb file
  def startCamera
    # Initial check for motion.pid file
    pid_exists = File.exist?("/var/www/test/pid/motion.pid")
    
    # Ensure that motion is NOT running
    if !pid_exists
      
      # Determine which video camera file exists; should only ever be one of these.
      video_ports = ['/dev/video0', '/dev/video1', '/dev/video2', '/dev/video3', '/dev/video4']
      video_port_exists = nil
      video_port_available = nil
      video_port_available = nil
      video_ports.each do |p|
        video_port_exists = File.exist?(p)
        if video_port_exists
          video_port_available = p
          break
        end      
      end
      
      # Pid folder contains symlink to thread1.conf that contains the location of the video device
      symlink_to_thread_conf = "/var/www/test/pid/thread1.conf"
      
      # Ensure that the symlink exists
      if (File.exist?(symlink_to_thread_conf))
        
        # The configuration file contains "videodevice /dev/video0" by default
        # Every time I start the camera, if the videodevice that's saved in the configuration does not match what the system has
        # Then overwrite the file with the correct filename
        videodevice_in_thread_conf = File.open(symlink_to_thread_conf).first
        videodevice_in_thread_conf.slice! "videodevice "
        
        if videodevice_in_thread_conf != video_port_available
          File.open(symlink_to_thread_conf, 'w') {
            |f| f.write("videodevice #{video_port_available}")
          }
        end
      end
      
      # Start Motion (-m option disables motion detection)
      start = system("/usr/local/bin/motion")
      
      # Sleep for 1.1 seconds to give Motion enough time to create PID file
      sleep 1.1
      
      @pid_now_exists = File.exist?("/var/www/test/pid/motion.pid")
      
      if @pid_now_exists
        # To avoid zombie processes, use simple system() call and don't print out PID; there is no return data for a system() call
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
    
    # Used solely for JSON/mobile view
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
