# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  HomeController.action_methods.each do |action|
    get "/#{action}", to: "home##{action}", as: "#{action}_page"
  end

  get 'user/imported_files', to: 'user#imported_files'
  get 'import', to: 'uploader#import'
  post 'import', to: 'uploader#upload'
  get 'user/contacts', to: 'user#contacts'
  get 'imported_files/:id/failed_registers',
      to: 'import_file#failed_registers', as: 'failed_registers'
end
