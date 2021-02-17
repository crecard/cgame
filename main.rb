$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require_relative './lib/creacard'

$card_pool = Creacard::Card.load_all_cards('./data/cards')

player_a = Creacard::Player.load_player('tzwm_1')
player_b = Creacard::Player.load_player('defend_ironclad_1')

combat = Creacard::Combat.new([[player_a], [player_b]])
combat.begin!

controller = Creacard::Controller.new(combat)
controller.begin!
