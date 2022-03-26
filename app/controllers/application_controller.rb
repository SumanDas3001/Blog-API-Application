class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, unless: -> { request.format.json? }
  include Response
  include JwtAuthenticate
end
