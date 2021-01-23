$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require_relative './lib/creacard'

player_a = Creacard::Player.new(100, Array.new(10, Creacard::StrikeCard.new))
player_b = Creacard::Player.new(100, Array.new(10, Creacard::StrikeCard.new))

combat = Creacard::Combat.new([player_a], [player_b])
combat.begin

combat.info
