class JsController < ApplicationController
  
  def scaffold
    routeSet = Rails.application.routes
    routes = routeSet.routes
    
    js = routes.map {|route| 
      route.defaults[:controller]  
    }.uniq.compact.map {|route|
      mapear_controllers route
    }.compact.join
    
    js << routes.map {|route| 
      mapear_actions route
    }.compact.join
    
    render :text => js.to_s
    
  end
  
  private
  def mapear_controllers route
    str = ""
    controller_name = "#{route.camelize.gsub(/\:\:/, ".")}Controller"
    if m = controller_name.match(/\./)
      str << "if(!#{m.pre_match}) var #{m.pre_match} = {};"
    end
    str << "#{controller_name} = function(){ AjaxUtil.call(this); }; #{controller_name}.prototype.routes = {};"
  end
  
  def mapear_actions route
    if route.defaults[:controller].present?
      controller_name = "#{route.defaults[:controller].camelize.gsub(/\:\:/, ".")}Controller"
      method = route.conditions[:request_method].present? ? route.conditions[:request_method].source[1..-2] : "GET"
      "#{controller_name}.prototype.routes[\"#{route.defaults[:action]}\"] = {url: \"#{route.path}\", method: \"#{method}\"};"
    else
      
    end
  end
  
end
