class GalleryController < ApplicationController
  
  before_filter :authenticate_user
  
  def index  
    
    if(params[:search] != "")
      @search_term = params[:search]
    else
      @search_term = "snapshot"
    end
    
    
    # REFERENCE #
    # http://css-plus.com/2010/09/create-your-own-jquery-image-slider/
    
    @snapshots = Snapshot.find(:all, :select => "filename", :conditions => ['filename LIKE ?', "%#{@search_term}%"])
    
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
