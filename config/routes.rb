Rails.application.routes.draw do
  root 'spells#index'

  post 'spells/search', to: 'spells#search'
  get 'spells', to: 'spells#index'

  scope :spells do
    get '/', to: 'spells#index'
    get '/:id', to: 'spells#show', as: :spell_details
    post '/search', to: 'spells#search'
  end
end