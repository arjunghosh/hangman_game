Rails.application.routes.draw do
  root 'hangman#index'
  resources :hangman, only: [:index, :create]

  # FIX: Correct route for resetting the game
  delete '/hangman/reset', to: 'hangman#destroy', as: 'reset_hangman'
end
