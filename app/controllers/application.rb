# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RorumMisc
  include RorumAcl

  before_filter :set_lang

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'cc83904fd72ab1281fce195b04599972'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  protected
  var_loader :category, :forum, :topic

  def set_lang
    Localization.lang = ((logged_in? and current_user.profile and LANGUAGES.values.detect { |lang| current_user.profile.language == lang }) or "en")
  end

  def languages
    LANGUAGES
  end

  helper_method :languages

end
