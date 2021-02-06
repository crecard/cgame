$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require_relative './lib/creacard'

cards = Creacard::Card.load_cards('./data/cards')

player_a = Creacard::Player.new('A', 40, cards.dup)
player_b = Creacard::Player.new('B', 100, cards.dup)

combat = Creacard::Combat.new([[player_a], [player_b]])
combat.begin!

controller = Creacard::Controller.new(combat)
controller.begin!
