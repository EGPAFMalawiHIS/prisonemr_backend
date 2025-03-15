class AddChangedByAndDateChangedToObs < ActiveRecord::Migration[7.0]
  def change
    add_column :obs, :changed_by, :integer
    add_column :obs, :date_changed, :datetime
  end
end
