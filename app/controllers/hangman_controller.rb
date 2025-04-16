require "net/http"
require "json"

class HangmanController < ApplicationController
  def index
    if session[:hangman].present?
      @hangman = Hangman.deserialize(session[:hangman])  # FIX: Ensure we deserialize session data
    else
      @hangman = Hangman.new(fetch_random_word.join)
      session[:hangman] = @hangman.serializable_hash  # Store as Hash
    end
  end

  def create
    if session[:hangman].present?
      @hangman = Hangman.deserialize(session[:hangman])  # FIX: Deserialize before using
    else
      @hangman = Hangman.new(fetch_random_word.join)
    end

    if params[:guess].present?
      @hangman.guess(params[:guess])  # Process user input
      session[:hangman] = @hangman.serializable_hash  # Store updated game state
    end

    redirect_to root_path
  end

  def destroy
    reset_session  # Reset game state
    redirect_to root_path
  end

  def end_game
    @hangman = Hangman.deserialize(session[:hangman])
    if @hangman && session[:user_id]
      user = User.find_by(id: session[:user_id])
      coins_awarded = 0
      if @hangman.won?
        coins_awarded = 10 # 10 coins for a win
        # Optional: Add streak logic here for bonus coins
        user.coins = (user.coins || 0) + coins_awarded
        user.save!
        flash[:notice] = "You won! +#{coins_awarded} HangCoins awarded!"
      end
      if user&.opt_in_email
        PlayerMailer.score_email(user, @hangman.score).deliver_later
      end
      Score.create(player_name: user.name, points: @hangman.score)
      session[:hangman] = nil
    end
    redirect_to leaderboard_path
  end

  private

  def fetch_random_word
    word = fetch_from_primary_api || fetch_from_backup_api || fetch_local_word
    word.upcase.split("")
  end

  def fetch_from_primary_api
    uri = URI("https://random-word-api.herokuapp.com/word")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data[0] if data.is_a?(Array) && data[0].is_a?(String)
  rescue StandardError
    nil
  end

  def fetch_from_backup_api
    uri = URI("https://api.api-ninjas.com/v1/randomword")
    request = Net::HTTP::Get.new(uri)
    request["X-Api-Key"] = "your_api_key_here" # Replace with your API key
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
    data = JSON.parse(response.body)
    data["word"] if data.is_a?(Hash) && data["word"].is_a?(String)
  rescue StandardError
    nil
  end

  def fetch_local_word
    %w[hangman ruby rails coding developer].sample
  end

  def current_player
    # Assuming a Player model exists and the user is logged in
    Player.find(session[:player_id])
  end
end
