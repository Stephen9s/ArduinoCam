class AnalysisController < ApplicationController
  
  before_filter :authenticate_user
  before_filter :check_for_mobile
  
  def index
    
    @count = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    time = Time.now
    @yearmonth = ""
    current_year = (time.strftime("%Y")).to_i
    
    
    if Analysis.exists?(1)      
      
      if !params["search_month"].nil? && !params["search_year"].nil?
        Analysis.update(1, :year => params["search_year"].to_s, :month => params["search_month"].to_s)
      end
      
    else
      entry = Analysis.new
      entry.id = 1
      entry.year = time.strftime("%Y")
      entry.month = time.strftime("%m")
      entry.save
    end
    
    
    saved_date = Analysis.find_by_id(1)
    @selected_year = saved_date.year
    @selected_month = saved_date.month
    @yearmonth = "#{saved_date.year}#{saved_date.month}"
    
    @list_of_months = [["Jan","01"],["Feb","02"],["Mar","03"],["Apr","04"],["May","05"],["Jun","06"],["Jul","07"],["Aug","08"],["Sep","09"],["Oct","10"],["Nov","11"],["Dec","12"]]
    
    @generated_years = Array.new
    
    for i in current_year.downto(current_year-5)
      @generated_years << i
    end

    snapshots = Snapshot.find(:all, :select => "filename,event_time_stamp", :conditions => ['event_time_stamp LIKE ?', "%#{@yearmonth}%"], :order => "id desc")
    @snapshot_count = snapshots.size
    
    if snapshots.size > 0
      
      snapshots.each do |snapshot|
        snapshot.filename.slice! "/var/www/test/app/assets/images/snapshots/"
          
          # The regex finds the string between the first '-' and second '-' that's present in the filename
          # From here, I extract the time information and display it on the page
          snapshot["truncated"] = snapshot.filename[/\-(.*?)-/,1]
          snapshot["day"] = snapshot.truncated[6..7]
          
          @count[snapshot["day"].to_i-1] = @count[snapshot["day"].to_i-1] + 1
      end
    end
    
    respond_to do |format|
      format.json { render :json => @count}
      format.html {}
    end
    
  end
    
end
