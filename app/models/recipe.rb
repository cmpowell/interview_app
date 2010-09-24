class Recipe < ActiveRecord::Base
  attr_accessible :instructions
  
  belongs_to :user
  
  validates :instructions, :presence => true,
                             :length => { :maximum => 256 }
  validates :user_id, :presence => true
  
  default_scope :order => 'recipes.created_at DESC'
  
  
end
