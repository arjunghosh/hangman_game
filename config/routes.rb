Rails.application.routes.draw do
  root "hangman#index"
  resources :hangman, only: [ :index, :create ]

  # FIX: Correct route for resetting the game
  delete "/hangman/reset", to: "hangman#destroy", as: "reset_hangman"

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: redirect("/")
  delete "/logout", to: "sessions#destroy"

  # Leaderboard route
  get "/leaderboard", to: "leaderboard#index"

  # Route for toggling email opt-in preference
  post "/users/toggle_email", to: "users#toggle_email"

  # Route for active users view
  get "/active_users", to: "leaderboard#active", as: "active_users"
end
