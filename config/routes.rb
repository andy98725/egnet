Rails.application.routes.draw do
  root 'main_pages#home'
  get '/about',                             to: 'main_pages#about'
  get '/contact',                           to: 'main_pages#contact'
  get '/base-wars',                         to: 'main_pages#index'
  get '/base-wars/patchNotes',              to: 'main_pages#patchNotes'
  get '/base-wars/patchNotes/raw',          to: 'main_pages#patchRaw'
  get '/base-wars/download/win',            to: 'main_pages#installerWindows'
  get '/base-wars/download/mac',            to: 'main_pages#installerMac'
  get '/base-wars/download/lin',            to: 'main_pages#installerLinux'
  get '/base-wars/download/version',        to: 'main_pages#installerNum'
  get '/base-wars/download/raw',            to: 'main_pages#download'
  get '/base-wars/download/raw/version',    to: 'main_pages#versionNum'
end
