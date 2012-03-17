module ApplicationHelper
  require 'digest/md5'
  
  def gravatar_url_for(email, options = {})
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}"
  end
end
