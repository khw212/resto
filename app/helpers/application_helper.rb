module ApplicationHelper

  def user_display(user)
    name=''
    if !user.login.blank? && !user.email.blank?
      name = "#{ user.login } (#{ user.email })"
    else
      if !user.login.blank?
        name = user.login
      else
        name = user.email
      end
    end
  end

  def job_application_image_tag(status)
    img = case status
      when 0
        'unread.png'
      when 1
        'read.png'
      when 2
        'favored.png'
      when 3
        'rejected.png'
    end
    image_tag img, :border => 0, :title => t("resto.messages.job_application.status.job_seeker.#{ status }")
  end
  
  def options_for_state(default)
    a = Carmen::states('US').clone
    a.unshift([])
    options_for_select(a, default)
  end
  
  def options_for_job_search_order(default)
    options_for_select([ [t('resto.messages.search.date'),'date'],[t('activerecord.attributes.job.state'),'state']], default)
  end
  
  # options[:text]  -- method for text, default name
  # options[:value] -- method for id, default id
  # options[:prompt] -- prompt text for select
  # default -- default value
  # ar_class -- active record class
  def options_from_model(ar_class, default, options = {})
    options[:text]  ||= :name
    options[:value] ||= :id
    options[:prompt] ||= t('resto.messages.search.any')
    
    collection = ar_class.all.collect {|p| [p.send(options[:text]), p.send(options[:value]).to_s] }
    collection = collection.unshift [options[:prompt], nil]
    options_for_select(collection, default)
  end
  
  def model_info_block(object, method)
    info_block object.class.human_attribute_name(method), object.send(method)
  end
  
  def info_block(label,data)
    text = ''
    text += content_tag(:span, label) 
    text += "\n"
    text += content_tag(:span, no_info_if_empty(data), :class => 'info')
    text += "\n<br />\n"
    text
  end
  
  def no_info_if_empty(data)
    data.blank? ? t('resto.form.hint.empty') : data
  end
  
  def render_profile_partial(subtemplate)
    # if logged_in?
    if current_user
      partial_name = current_user.profileable_type.underscore
    # safely assume that this is a registration process
    else
      partial_name = params[:id].underscore      
    end
    render :partial => "users/#{ subtemplate }_#{ partial_name }"
  end
  
  # resume helper
  
  # generated using
  # a = []
  # 20.step(100,5)    { |i| a << ["$#{i} / hour",i] }
  # 125.step(200,25)  { |i| a << ["$#{i} / hour",i] }
  # 250.step(300,50)  { |i| a << ["$#{i} / hour",i] }
  def options_for_hourly_pay_rate
    [["$20 / hour", 20], ["$25 / hour", 25], ["$30 / hour", 30], ["$35 / hour", 35], ["$40 / hour", 40], ["$45 / hour", 45], ["$50 / hour", 50], ["$55 / hour", 55], ["$60 / hour", 60], ["$65 / hour", 65], ["$70 / hour", 70], ["$75 / hour", 75], ["$80 / hour", 80], ["$85 / hour", 85], ["$90 / hour", 90], ["$95 / hour", 95], ["$100 / hour", 100], ["$125 / hour", 125], ["$150 / hour", 150], ["$175 / hour", 175], ["$200 / hour", 200], ["$250 / hour", 250], ["$300 / hour", 300]]
  end
  
  # generated using
  # a = []
  # 25_000.step(100_000,5_000)    { |i| a << ["$#{i/12} / month",i/12] }
  # 125_000.step(200_000,10_000)  { |i| a << ["$#{i/12} / month",i/12] }
  def options_for_monthly_salary
    [["$2083 / month", 2083], ["$2500 / month", 2500], ["$2916 / month", 2916], ["$3333 / month", 3333], ["$3750 / month", 3750], ["$4166 / month", 4166], ["$4583 / month", 4583], ["$5000 / month", 5000], ["$5416 / month", 5416], ["$5833 / month", 5833], ["$6250 / month", 6250], ["$6666 / month", 6666], ["$7083 / month", 7083], ["$7500 / month", 7500], ["$7916 / month", 7916], ["$8333 / month", 8333], ["$10416 / month", 10416], ["$11250 / month", 11250], ["$12083 / month", 12083], ["$12916 / month", 12916], ["$13750 / month", 13750], ["$14583 / month", 14583], ["$15416 / month", 15416], ["$16250 / month", 16250]]
  end

  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
  
  
end
