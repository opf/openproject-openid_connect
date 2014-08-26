OpenProject::Application.routes.draw do
  get '/auth/check_session', to: 'sessions#check_session'
  get '/auth/session_state', to: 'sessions#session_state'
end
