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
  
  def cameraOps
    @status = "No change."
    
    destroy_process = system("kill $(pidof motion)")

    if destroy_process

        @status = "Motion destroyed."
        destroy_pid_file = system("rm -f $(find /var/www/test -name 'motion.pid')")
        
        if destroy_pid_file
          @status = "Motion process destroyed; motion.pid removed forcefully."
          @button_label = "Turn on camera"
        end

    else
      start = system("/usr/local/bin/motion -m")
      @status = "Static Camera Started."
      @button_label = "Turn off camera."
      
    end
    
    respond_to do | format |
        format.html   { redirect_to index_path }
        format.js
    end
    
  end
  
end
