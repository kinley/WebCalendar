class CreateRepeats < ActiveRecord::Migration
  def self.up
    create_table :repeats do |t|
      t.integer :event_id
      t.integer :repeating_type
      t.integer :repeating_day

      t.timestamps
    end
  end

  def self.down
    drop_table :repeats
  end
end
