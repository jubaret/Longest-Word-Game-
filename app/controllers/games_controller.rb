require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    i = 0
    grid = []
    while i < 10
      grid << ('A'..'Z').to_a.sample
      i += 1
    end
    @letters = grid
  end

  def letters_ok?(grid, attempt)
    attempt.each do |letter|
      if grid.include?(letter.upcase) == false
        return false
      else
        grid.delete_at(grid.index(letter.upcase))
      end
    end
    return true
  end

  def an_english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    api_result = URI.open(url).read
    api_result = JSON.parse(api_result)
    return api_result['found']
  end

  def score
    grid = params['letters'].chars
    attempt = params['word'].chars
    if letters_ok?(grid, attempt)
      if an_english_word?(params['word'])
        @score = params['word'].length * params['word'].length
        @message = "Congratulations! #{params['word']} is a valid English word!"
      else
        @score = 0
        @message = "Sorry by #{params['word']} does not seem to be a valid English word"
      end
    else
      @score = 0
      @message = "Sorry but #{params['word']} can't be built out of #{grid}"
    end
  end
end
