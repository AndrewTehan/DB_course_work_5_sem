class AddRankToMasters < ActiveRecord::Migration[6.1]
  def change
    add_column :masters, :rank, :integer
  end
end