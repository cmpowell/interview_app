class AddRecipeFields < ActiveRecord::Migration
  def self.up
    add_column :recipes, :title, :string
    add_column :recipes, :num_served, :int
    add_column :recipes, :ingredients, :text
  end

  def self.down
    remove_column :recipes, :title
    remove_column :recipes, :num_served
    remove_column :recipes, :ingredients
  end
end
