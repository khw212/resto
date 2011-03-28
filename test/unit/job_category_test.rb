require File.dirname(__FILE__) + '/../test_helper'

class JobCategoryTest < ActiveSupport::TestCase
  should_have_db_column :name_en, :name_zh_cn, :name_zh_tw
end
