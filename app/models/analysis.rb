class Analysis < ActiveRecord::Base
  # Model used to access analyses table
  # Should only have one row
  attr_accessible :year, :month
end
