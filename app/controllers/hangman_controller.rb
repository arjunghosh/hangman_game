class HangmanController < ApplicationController
  def index
    if session[:hangman].present?
      @hangman = Hangman.deserialize(session[:hangman])  # FIX: Ensure we deserialize session data
    else
      @hangman = Hangman.new(random_word)
      session[:hangman] = @hangman.serializable_hash  # Store as Hash
    end
  end

  def create
    if session[:hangman].present?
      @hangman = Hangman.deserialize(session[:hangman])  # FIX: Deserialize before using
    else
      @hangman = Hangman.new(random_word)
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

  private

  def random_word
    ["developer", "ruby", "rails", "hangman", "controller"].sample  # Random words
  end
end
