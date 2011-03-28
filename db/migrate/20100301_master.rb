class CreateMaster < ActiveRecord::Migration
  def self.up
  create_table "addresses", :force => true do |t|
    t.string  "telephone"
    t.text    "address"
    t.string  "city"
    t.string  "state"
    t.string  "postal_code"
    t.integer "addressable_id",   :null => false
    t.string  "addressable_type", :null => false
  end

  add_index "addresses", ["id"], :name => "index_addresses_on_id"

  create_table "admins", :force => true do |t|
    t.string "name", :limit => 50
  end

  add_index "admins", ["id"], :name => "index_admins_on_id"

  create_table "business_types", :force => true do |t|
    t.string "name_en",    :limit => 50
    t.string "name_zh_cn", :limit => 50
    t.string "name_zh_tw", :limit => 50
  end

  add_index "business_types", ["id"], :name => "index_business_types_on_id"

  create_table "educations", :force => true do |t|
    t.string "name_en",    :limit => 50
    t.string "name_zh_cn", :limit => 50
    t.string "name_zh_tw", :limit => 50
  end

  add_index "educations", ["id"], :name => "index_educations_on_id"

  create_table "employers", :force => true do |t|
    t.string  "business_name",    :limit => 50,                    :null => false
    t.integer "business_type_id",                                  :null => false
    t.string  "telephone",        :limit => 50
    t.text    "address"
    t.string  "city",             :limit => 50
    t.string  "state",            :limit => 2
    t.string  "postal_code",      :limit => 5
    t.boolean "confidential",                   :default => false, :null => false
    t.string  "confirmed",                      :default => "f",   :null => false
    t.string  "subpath",          :limit => 50
  end

  add_index "employers", ["id"], :name => "index_employers_on_id"

  create_table "experiences", :force => true do |t|
    t.integer "job_category_id"
    t.integer "resume_id"
    t.integer "year_used"
    t.integer "years_of_experience"
  end

  add_index "experiences", ["id"], :name => "index_experiences_on_id"

  create_table "job_applications", :force => true do |t|
    t.integer  "job_seeker_id"
    t.integer  "employer_id"
    t.integer  "job_id"
    t.integer  "status",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_applications", ["employer_id"], :name => "index_job_applications_on_employer_id"
  add_index "job_applications", ["id"], :name => "index_job_applications_on_id"
  add_index "job_applications", ["job_id"], :name => "index_job_applications_on_job_id"
  add_index "job_applications", ["job_seeker_id"], :name => "index_job_applications_on_job_seeker_id"

  create_table "job_categories", :force => true do |t|
    t.string "name_en",    :limit => 50
    t.string "name_zh_cn", :limit => 50
    t.string "name_zh_tw", :limit => 50
  end

  add_index "job_categories", ["id"], :name => "index_job_categories_on_id"

  create_table "job_histories", :force => true do |t|
    t.integer "resume_id"
    t.string  "employer_name",  :limit => 50
    t.string  "employer_city",  :limit => 50
    t.string  "employer_state", :limit => 2
    t.string  "position"
  end

  add_index "job_histories", ["id"], :name => "index_job_histories_on_id"

  create_table "job_seekers", :force => true do |t|
    t.string  "name",                     :limit => 50,                    :null => false
    t.boolean "authorized_to_work_in_us",               :default => false, :null => false
    t.string  "gender",                   :limit => 1,                     :null => false
    t.string  "telephone",                :limit => 50
    t.text    "address"
    t.string  "city",                     :limit => 50
    t.string  "state",                    :limit => 2
    t.string  "postal_code",              :limit => 5
  end

  add_index "job_seekers", ["id"], :name => "index_job_seekers_on_id"

  create_table "jobs", :force => true do |t|
    t.string   "postal_code",         :limit => 5
    t.integer  "employer_id",                       :null => false
    t.string   "position_name",                     :null => false
    t.string   "city",                :limit => 50
    t.string   "state",               :limit => 2
    t.integer  "job_category_id",                   :null => false
    t.integer  "position_type_id",                  :null => false
    t.integer  "education_id"
    t.text     "general_description"
    t.text     "job_requirements"
    t.date     "date_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "experience_level",    :limit => 50
  end

  add_index "jobs", ["id"], :name => "index_jobs_on_id"

  create_table "moderators", :force => true do |t|
    t.string "name", :limit => 50
  end

  add_index "moderators", ["id"], :name => "index_moderators_on_id"

  create_table "position_type", :force => true do |t|
    t.string "name"
  end

  create_table "position_types", :force => true do |t|
    t.string "name_en",    :limit => 50
    t.string "name_zh_cn", :limit => 50
    t.string "name_zh_tw", :limit => 50
  end

  add_index "position_types", ["id"], :name => "index_position_types_on_id"

  create_table "resumes", :force => true do |t|
    t.integer "job_seeker_id",                          :null => false
    t.string  "name",                     :limit => 50
    t.boolean "public"
    t.text    "objective"
    t.date    "date_available"
    t.integer "desired_position_type_id"
    t.integer "desired_monthly_salary"
    t.integer "desired_hourly_pay_rate"
    t.text    "preferred_locations"
    t.integer "education_id"
    t.string  "institution",              :limit => 50
  end

  add_index "resumes", ["id"], :name => "index_resumes_on_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",             :limit => 50,                    :null => false
    t.string   "crypted_password",  :limit => 128,                   :null => false
    t.string   "password_salt",     :limit => 20,                    :null => false
    t.string   "persistence_token", :limit => 128,                   :null => false
    t.string   "perishable_token",  :limit => 20,                    :null => false
    t.integer  "profileable_id",                                     :null => false
    t.string   "profileable_type",  :limit => 30,                    :null => false
    t.boolean  "active",                           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",             :limit => 50
  end

  add_index "users", ["email"], :name => "index_users_on_email"
     
  end

  def self.down
    drop_table :addresses
    drop_table :admins
    drop_table :business_types
    drop_table :educations
    drop_table :employers
    drop_table :experiences
    drop_table :job_applications
    drop_table :job_categories
    drop_table :job_histories
    drop_table :job_seekers
    drop_table :jobs
    drop_table :moderators
    drop_table :position_type
    drop_table :position_types
    drop_table :resumes
    drop_table :sessions
    drop_table :users    
  end
end