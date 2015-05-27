module OmnitureHelper
  def omniture_url
    url = omniture_index_url
    param_pair = omniture_trackable_properties.collect{|p| omniture_query_param(p)}

    "#{url}?#{param_pair.join('&')}"
  end

  def omniture_trackable_properties
    [:page_name,
     :user_id,
     :application_name,
     :ask_article_id,
     :learning_course_id,
     :article_id,
     :search]
  end

  def omniture_query_param(prop)
    "#{prop}=#{self.send(prop)}"
  end

  def application_name
    Omniture.application_name
  end

  def search
    if controller_name == 'search' && action_name == 'show'
      CGI.parse(URI.parse(request.url).query)["search"].first
    end
  end

  def article_id
    if controller_name == 'articles' && action_name == 'show'
      request.url.split('/').last
    end
  end

  def ask_article_id
    if controller_name == 'ask_articles' && action_name == 'show'
      request.url.split('/').last
    end
  end

  def learning_course_id
    if controller_name == 'learning_courses' && action_name == 'show'
      request.url.split('/').last
    end
  end

  def user_id
    begin
      current_user.pidx
    rescue
      "unknown"
    end
  end

  def asyncomni_content_tag
    if Omniture.enabled?
      tag(:iframe, id: 'omnitureFrame', name: 'omnitureFrame', width: '0', height: '0', style: 'visibility:hidden', data: {'page-name' =>  page_name, 'omniture-url' =>  omniture_url })
    end
  end

  def asyncomni_angular_content_tag
    if Omniture.enabled?
      tag('asyncomni-directive', id: 'omnitureFrame', name: 'omnitureFrame', width: '0', height: '0', style: 'visibility:hidden', data: {'page-name' =>  page_name, 'omniture-url' =>  omniture_url })
    end
  end

  def page_name
    name = []
    name << application_name
    name << controller_name.gsub('/','_').camelize
    name << action_name.gsub('/','_').camelize
    name.join('_')
  end

  def omniture_formatted_time
    Time.now.strftime('%m/%d/%Y %I:%M:%S %p')
  end
end
