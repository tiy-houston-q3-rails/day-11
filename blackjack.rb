require 'pry'

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def print_status
    puts cards.map(&:display).join(", ")

  end

  def take_card(card)
    @cards << card
  end
end


class Card
  def initialize suit, face, value
    @suit = suit
    @face = face
    @value = value
  end

  def display
    [@face, print_suit(@suit)].join("")
  end

  def print_suit(suit)
    {spades: "♤", clubs: "♧", hearts: "♡",diamonds: "♢"}[suit]
  end
end

class Deck
  def initialize
    @cards = []

    [:hearts, :clubs, :spades, :diamonds].each do |suit|
      [2, 3, 4, 5, 6, 7, 8, 9, 10].each do |face|
        number = face
        @cards << Card.new(suit, face, number)
      end
    end

    # face_cards
    [:hearts, :clubs, :spades, :diamonds].each do |suit|
      {"J"=>10, "Q"=>10, "K"=>10, "A"=> 11}.each do |face, value|
        @cards << Card.new(suit, face, value)
      end
    end

    @cards = shuffle_deck
  end

  def shuffle_deck
    @cards.shuffle
  end

  def deal_card
    # takes 1 card from array and returns it.
    # array should not have original card left
    @cards.shift
  end
end

class Blackjack

  attr_accessor :player_hand, :dealer_hand, :deck


  def run_game
    @player_hand= Hand.new
    @dealer_hand= Hand.new
    @deck = Deck.new

    deal(number_of_cards: 2, hand: @player_hand)
    deal(number_of_cards: 2, hand: @dealer_hand)

    show_hands
  end

  def deal(number_of_cards:, hand:)
    number_of_cards.times do
      hand.take_card(deck.deal_card)
    end
  end

  def show_hands
    [player_hand, dealer_hand].each do |hand|
      hand.print_status
    end
  end
end

game = Blackjack.new
game.run_game
