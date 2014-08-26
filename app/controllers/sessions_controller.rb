class SessionsController < ApplicationController
  layout false

  def check_session
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
  end

  def session_state
    if session[:oidc_state]
      render text: session[:oidc_state]
    else
      render text: 'user does not seem to be logged in', status: 401
    end
  end
end
