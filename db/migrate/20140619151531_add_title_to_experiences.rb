class AddTitleToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :title, :string
  end
end
