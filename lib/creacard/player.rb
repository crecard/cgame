class Creacard::Player
  attr_reader :name
  attr_reader :max_health, :health, :energy, :turn_energy, :block, :draw_count

  # :built, :unused, :hand, :used, :discarded
  attr_reader :decks
  attr_reader :combat, :team

  INIT_HEALTH = 100
  INIT_ENERGY = 3
  INIT_BLOCK = 0
  INIT_DRAW_COUNT = 3

  HAND_UP_LIMIT = 10

  class NotEnoughFeeError < StandardError; end

  def initialize(name = "someone #{rand(4)}", max_health = INIT_HEALTH, built_dect)
    @name = name
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
      used: [],
      discarded: [],
    }
  end

  def new_combat!(combat, team)
    @combat = combat
    @team = team
    @decks[:unused] = @decks[:built].shuffle
    @decks[:hand] = []
    @decks[:used] = []
    @decks[:discarded] = []
  end

  def new_turn!
    @energy = @turn_energy

    need_draw = @draw_count
    while need_draw > 0 do
      if @decks[:unused].empty?
        break if @decks[:used].empty?
        @decks[:unused] = @decks[:used].shuffle
        @decks[:used] = []
      end
      @decks[:hand] = @decks[:unused].pop(@draw_count)
      need_draw -= 1
    end
  end

  def end_turn!
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

  def get_damage!(damage:)
    if @block >= damage
      @block -= damage
      puts "#{name} 护甲减少 #{damage}"
      return
    end

    puts "#{name} 护甲减少 #{@block}" if @block > 0
    damage -= @block
    @block = 0
    @health -= damage
    puts "#{name} 生命减少 #{damage}"
  end

  def use_the_card!(deck_type, card_index)
    raise NotEnoughFeeError unless has_energy?(@decks[deck_type][card_index].fee)

    card = @decks[deck_type].delete_at(card_index)
    @energy -= card.fee
    card.act!(self, @combat)
    @decks[:used] << card
  end

  def player_info
    "Player #{@name}\n血量: #{@health}/#{@max_health} | 能量: #{@energy} | 护甲: #{@block} | 手牌数: #{@decks[:hand].count}"
  end

  def deck_info(deck_type)
    @decks[deck_type.to_sym].map.with_index do |card, i|
      "#{i + 1}) #{card.info}"
    end
  end
end
