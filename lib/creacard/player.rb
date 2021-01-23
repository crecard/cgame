module Creacard
  class Player
    attr_accessor :max_health, :health, :energy, :turn_energy, :block, :draw_count
    attr_accessor :decks
    attr_accessor :combat

    INIT_HEALTH = 100
    INIT_ENERGY = 3
    INIT_BLOCK = 0
    INIT_DRAW_COUNT = 4

    HAND_UP_LIMIT = 10

    def initialize(max_health = INIT_HEALTH, built_dect)
      @max_health = max_health
      @health = @max_health
      @turn_energy = INIT_ENERGY
      @energy = @turn_energy
      @block = INIT_BLOCK
      @draw_count = INIT_DRAW_COUNT

      @decks = {
        built: built_dect,
        unused: [],
        hand: [],
        discarded: [],
        depleted: []
      }
    end

    def new_combat
      @decks[:unused] = @decks[:built].shuffle!
      @decks[:hand] = @decks[:unused].pop(@draw_count)
      @decks[:discarded] = []
      @decks[:depleted] = []
    end

    def is_dead?
      @health <= 0
    end

    def is_live?
      !is_dead?
    end

    def has_energy?(fee = 1)
      @energy >= fee
    end

    def get_damage(damage)
      if @block >= damage
        @block -= damage
        return
      end

      damage -= @block
      @block = 0
      @health -= damage
    end

    def info
      puts "血量: #{@health}/#{@max_health} | 能量: #{@energy} | 护甲: #{@block}"
      deck_info(:built)
    end

    def deck_info(deck_type)
      deck = @decks[deck_type]
      deck.each_with_index do |card, i|
        puts "#{i}: #{card.name}"
        puts "#{card.description}"
      end
    end
  end
end
