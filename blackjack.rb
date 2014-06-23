require 'pry'
require 'io/console'

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def status
    cards.map(&:display).join(", ")
  end

  def take_card(card)
    @cards << card
  end

  def value
    cards.map(&:value).inject(:+)
  end
end

class DealerHand < Hand

  def status(show_all_cards)
    if show_all_cards
      cards.map(&:display).join(", ")
    else
      "XX, #{cards.last.display}"
    end
  end

end

class Card
  attr_reader :value

  def initialize suit, face, value
    @suit = suit
    @face = face
    @value = value
  end

  def display
    [@face, suit_as_graphic].join("")
  end

  def suit_as_graphic
    hash = {spades: "♤", clubs: "♧", hearts: "♡",diamonds: "♢"}
    return hash[@suit]
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
    @dealer_hand= DealerHand.new
    @deck = Deck.new

    deal(number_of_cards: 2, hand: @player_hand)
    deal(number_of_cards: 2, hand: @dealer_hand)

    show_hands

    print_header

    @player_can_hit = true
    play_player
    play_dealer

    print_game_status

  end

  def player_has_not_busted
    @player_can_hit and @player_hand.value < 21
  end

  def play_player
    # First Loop -> Player
    while player_has_not_busted?

      if hit?
        deal(number_of_cards: 1, hand: @player_hand)
        show_hands
      else
        @player_can_hit = false
      end
    end

  end


  def play_dealer
    @show_dealer_cards = true
    # First Loop -> Dealer
    while @dealer_hand.value < 16
      deal(number_of_cards: 1, hand: @dealer_hand)
    end
  end

  def deal(number_of_cards:, hand:)
    number_of_cards.times do
      hand.take_card(deck.deal_card)
    end
  end

  def show_hands

    puts "YOU: #{player_hand.status}"
    puts "\n"
    puts "THE DEALER: #{dealer_hand.status(@show_dealer_cards)}"
    puts "\n\n"
  end

  def hit?
    case STDIN.getch.downcase
    when "h"
      return true
    when "s"
      return false
    when "q"
      exit
    else print_header
    end
  end

  def print_header
    10.times do
      puts "\n"
    end
    puts "-------------------------------------"
    puts "|      H for Hit, S for stand       |"
    puts "-------------------------------------"
    puts "\n"
  end

  def print_game_status
    10.times do
      puts "\n"
    end
    show_hands
    puts "YOU: #{@player_hand.value} | DEALER: #{@dealer_hand.value}"
  end

end

game = Blackjack.new
game.run_game
