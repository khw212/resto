class BusinessType < ActiveRecord::Base
  has_many :employers
  
  translatable_columns :name, :full_locale => true
  validates_translation_of :name
  
  def name
    self.send('name' + '_' + I18n.locale.to_s.downcase.gsub('-','_'))
  end
end
