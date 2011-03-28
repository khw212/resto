class Address < ActiveRecord::Base
  belongs_to :adressable, :polymorphic => true
  
  # validation
  validates_inclusion_of :state, :in => Carmen::state_codes
  
end
