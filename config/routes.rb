# frozen_string_literal: true

Rails.application.routes.draw do
  root "/#{I18n.locale}", controller: 'users', action: 'index'

  scope ':locale', locale: /ru|en/ do
    devise_for :users

    resources :clients, controller: :users, only: %i[index show] do
      resources :visits
    end

    resources :users, only: %i[destroy edit update]

    post '/search', to: 'search#search'
    get '/admin_index', to: 'visits#admin_index'
    get '/clients_list', to: 'users#clients'
    get '/team', to: 'users#team'
    put '/change_status', to: 'visits#change_status'
    get '/services', to: 'users#services'
    get '/portfolio', to: 'users#portfolio'
    get '*path', to: 'errors#error_404', via: :all
  end
end
