require './player.rb'
require './combat.rb'
require './card.rb'

player_a = Player.new(100, Array.new(10, StrikeCard.new))
player_b = Player.new(100, Array.new(10, StrikeCard.new))

combat = Combat.new([player_a], [player_b])
combat.begin

combat.info
