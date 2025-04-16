class PlayerMailer < ApplicationMailer
  default from: "no-reply@hangman.com"

  def score_email(player, score)
    @player = player
    @score = score
    mail(to: @player.email, subject: "Your Hangman Game Score")
  end
end
