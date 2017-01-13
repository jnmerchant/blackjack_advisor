require_relative 'blackjack_advisor_options'
#install rubocop
players_hand = []

def get_card_value(a_card)
  face_cards = ["J", "K", "Q"]
  number_cards = [2, 3, 4, 5, 6, 7, 8, 9, 10]

  if number_cards.include?(a_card.to_i)
    card_value = a_card.to_i
  elsif face_cards.include?(a_card)
    card_value = 10
  elsif a_card == "A"
    card_value = 11
  end
end

def get_hand_type(first_card, second_card)
  if first_card == second_card
    "Pair"
  elsif first_card == 11 or second_card == 11
    "Soft"
  else
    "Hard"
  end
end

def get_players_hand_value(players_hand)
  players_hand['first_card_value'] + players_hand['second_card_value']
end

def convert_advice_code(advice_parameters)
  advice_codes = {'H' => "Hit", 'S' => "Stand", 'P' => "Split", 'Dh' => "Double if possible, otherwise Hit",
    'Ds' => "Double if possible, otherwise Stand"}
  players_advice_code = advice_parameters['action']
  advice = advice_codes[players_advice_code]
  return advice
end

def get_advice(players_hand, hand_options)
  advice_parameters = {}
  if players_hand['hand_type'] == "Pair"
    value_players_hand = get_players_hand_value(players_hand)/2
  else
    value_players_hand = get_players_hand_value(players_hand)
  end

  advice_parameters = hand_options.find {|hand_option_hash| hand_option_hash['dealer_value'] ==
    players_hand['dealer_card_value'] && hand_option_hash['player_value'] == value_players_hand}
  advice_to_player = convert_advice_code(advice_parameters)
  return advice_to_player
end

puts "Please enter your first card:"
first_card = gets.chomp
first_card_value = get_card_value(first_card.upcase)

puts "Please enter your second card:"
second_card = gets.chomp
second_card_value = get_card_value(second_card.upcase)

puts "Please enter the Dealer's card"
dealer_card = gets.chomp
dealer_card_value = get_card_value(dealer_card.upcase)

hand_type = get_hand_type(first_card_value, second_card_value)

players_hand = {'hand_type' => hand_type,'first_card_value' => first_card_value,
  'second_card_value' => second_card_value, 'dealer_card_value' => dealer_card_value}

if players_hand['hand_type'] == "Pair"
  hand_options = $pair_options
elsif players_hand['hand_type'] == "Hard"
  hand_options = $hard_options
elsif players_hand['hand_type'] == "Soft"
  hand_options = $soft_options
end

player_advice = get_advice(players_hand, hand_options)

puts "You are holding " + get_players_hand_value(players_hand).to_s
puts "If I were you, I would " + player_advice.upcase + " on this hand."
