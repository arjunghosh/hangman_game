class Hangman
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :word, :wrong_guesses, :guesses

  def initialize(word)
    super()
    @word = word.downcase
    @guesses = []
    @wrong_guesses = []
  end

  def guess(letter)
    letter = letter.downcase.strip
    return unless letter.match?(/\A[a-z]\z/)  # Only allow single letters

    if @word.include?(letter)
      @guesses << letter unless @guesses.include?(letter)
    else
      @wrong_guesses << letter unless @wrong_guesses.include?(letter)
    end
  end

  def display_word
    @word.chars.map { |char| @guesses.include?(char) ? char : '_' }.join(' ')
  end

  def game_over?
    won? || lost?
  end

  def won?
    (@word.chars - @guesses).empty?
  end

  def lost?
    @wrong_guesses.length >= 6
  end

  def attributes
    { 'word' => word, 'wrong_guesses' => wrong_guesses, 'guesses' => guesses }
  end

  # ✅ FIX: Define `deserialize` correctly as a **class method**
  def self.deserialize(attributes)
    return nil if attributes.nil?  # Prevent nil errors

    hangman = self.new(attributes['word'])
    hangman.wrong_guesses = attributes['wrong_guesses'] || []
    hangman.guesses = attributes['guesses'] || []
    hangman
  end
end
