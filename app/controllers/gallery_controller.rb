class GalleryController < ApplicationController
  
  before_filter :authenticate_user
  
  def index  
    
    @search_term = "snapshot"
    
    if(params[:search] != "")
      @search_term = params[:search]
    else
      @search_term = "snapshot"
    end
    
    
    # REFERENCE #
    # http://css-plus.com/2010/09/create-your-own-jquery-image-slider/
    if (params[:search_motiondetection] == "1")
      @snapshots = Snapshot.find(:all, :select => "filename,event_time_stamp", :conditions => ['filename LIKE ? and event_time_stamp != ?', "%#{@search_term}%", ""], :order => "id desc", :limit => 100)
    else
      @snapshots = Snapshot.find(:all, :select => "filename,event_time_stamp", :conditions => ['filename LIKE ? and event_time_stamp = ?', "%#{@search_term}%", ""], :order => "id desc", :limit => 100)
    end
    
    @snapshots.each do |snapshot|
        snapshot.filename.slice! "/var/www/test/app/assets/images/snapshots/"
        
        # The regex finds the string between the first '-' and second '-' that's present in the filename
        # From here, I extract the time information and display it on the page
        snapshot["truncated"] = snapshot.filename[/\-(.*?)-/,1]
        snapshot["year"] = snapshot.truncated[0..3]
        snapshot["month"] = snapshot.truncated[4..5]
        snapshot["day"] = snapshot.truncated[6..7]
        snapshot["hour"] = snapshot.truncated[8..9]
        snapshot["minute"] = snapshot.truncated[10..11]
        snapshot["second"] = snapshot.truncated[12..13]
    end
    
  end
  
end
