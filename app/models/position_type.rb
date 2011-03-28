class PositionType < ActiveRecord::Base
  has_many :jobs
  has_many :resume, :foreign_key => :desired_position_type_id
  
  translatable_columns :name, :full_locale => true
  validates_translation_of :name
  
  def name
    self.send('name' + '_' + I18n.locale.to_s.downcase.gsub('-','_'))
  end
end
