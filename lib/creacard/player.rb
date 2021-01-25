class Creacard::Player
  attr_reader :max_health, :health, :energy, :turn_energy, :block, :draw_count

  # :built, :unused, :hand, :used, :discarded
  attr_reader :decks
  attr_reader :combat, :team_index

  INIT_HEALTH = 100
  INIT_ENERGY = 3
  INIT_BLOCK = 0
  INIT_DRAW_COUNT = 4

  HAND_UP_LIMIT = 10

  VIEW_TYPES_PUBLIC = :public.freeze
  VIEW_TYPES_PRIVATE = :private.freeze

  class NotEnoughFeeError < StandardError; end

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
      used: [],
      discarded: [],
    }
  end

  def new_combat(combat, team_index)
    @combat = combat
    @team_index = team_index
    @decks[:unused] = @decks[:built].shuffle!
    @decks[:hand] = @decks[:unused].pop(@draw_count)
    @decks[:used] = []
    @decks[:discarded] = []
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

  def get_damage(damage:)
    if @block >= damage
      @block -= damage
      return
    end

    damage -= @block
    @block = 0
    @health -= damage
  end

  def use_the_card!(deck_type, card_index)
    raise NotEnoughFeeError unless has_energy?(@decks[deck_type][card_index].fee)

    card = @decks[deck_type].delete_at(card_index)
    @energy -= card.fee
    card.act(self, @combat)
  end

  def player_info(view = VIEW_TYPES_PUBLIC)
    case view
    when VIEW_TYPES_PUBLIC
      "血量: #{@health}/#{@max_health} | 护甲: #{@block}"
    when VIEW_TYPES_PRIVATE
      "血量: #{@health}/#{@max_health} | 能量: #{@energy} | 护甲: #{@block}"
    end
  end

  def deck_info(deck_type)
    @decks[deck_type].map.with_index do |card, i|
      "#{i + 1}) #{card.info}"
    end
  end
end
