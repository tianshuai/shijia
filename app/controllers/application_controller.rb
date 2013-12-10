class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #加载公共方法模块
  include PublicSessionsHelper
  include PublicAuthHelper
  include PublicImgHelper
  include PublicShowHelper
end
