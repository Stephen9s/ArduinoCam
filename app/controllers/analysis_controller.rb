class AnalysisController < ApplicationController
  before_filter :authenticate_user
  
  def index
    
    @count = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    time = Time.now
    @yearmonth = time.strftime("%Y%m")
    
    snapshots = Snapshot.find(:all, :select => "filename,event_time_stamp", :conditions => ['event_time_stamp LIKE ?', "%#{@yearmonth}%"], :order => "id desc")
    
    snapshots.each do |snapshot|
      snapshot.filename.slice! "/var/www/test/app/assets/images/snapshots/"
        
        # The regex finds the string between the first '-' and second '-' that's present in the filename
        # From here, I extract the time information and display it on the page
        snapshot["truncated"] = snapshot.filename[/\-(.*?)-/,1]
        snapshot["day"] = snapshot.truncated[6..7]
        
        @count[snapshot["day"].to_i-1] = @count[snapshot["day"].to_i-1] + 1
    end
    
    respond_to do |format|
      format.json { render :json => @count.as_json}
      format.html {}
    end
  end
end
