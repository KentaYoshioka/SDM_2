Rails.application.routes.draw do
  resources :work_tests
  get 'assign_shift/index'
  get 'show_reports/index'
  get 'teaching_assistants/index'
  get 'courses/index'
  get 'top/index'
  root "top#index"

  post '/check_data', to: "show_reports#check_data"

  post '/search', to: "assign_shift#search", as: 'search'
  post '/add_TA', to: "assign_shift#add_TA", as: 'add_TA'
  post '/delete_TA', to: "assign_shift#delete_TA", as: 'delete_TA'
  post '/add_work_time', to: "assign_shift#add_work_time", as: 'add_work_time'
  post '/delete_work_time', to: "assign_shift#delete_work_time", as: 'delete_work_time'
  post '/add_assignment', to: "assign_shift#add_assignment", as: 'add_assignment'
  post '/delete_assgnment', to: "assign_shift#delete_assgnment", as: 'delete_assgnment'
  get '/show_reports', to: 'show_reports#index'
  get '/show_reports/search', to: 'show_reports#search'
  get '/show_reports/write_excel1', to: 'show_reports#write_excel1'
  get '/show_reports/write_excel2', to: 'show_reports#write_excel2'
  get '/download_excel', to: 'show_reports#download_excel', as: 'download_excel'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
