class CreateSnapshots < ActiveRecord::Migration
  # CREATE TABLE security (camera int, filename char(80) not null, frame int, file_type int, time_stamp timestamp without time zone, event_time_stamp timestamp without time zone);
  def up  
    create_table :snapshots do |t|
      t.integer :camera
      t.string :filename, :null => false
      t.integer :frame
      t.integer :file_type
      t.datetime :time_stamp
      t.datetime :event_time_stamp
    end
  end
 
  def down
    drop_table :snapshots
  end
end
