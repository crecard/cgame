require 'yaml'

class Creacard::Player
  attr_reader :name, :max_health, :turn_energy, :draw_count
  attr_reader :health, :energy, :block, :statuses

  # :built, :unused, :hand, :used, :exhausted, :hang
  attr_reader :decks
  attr_reader :combat, :team

  attr_accessor :is_block_expire, :can_draw_this_turn

  INIT_HEALTH = 100
  INIT_ENERGY = 3
  INIT_BLOCK = 0
  INIT_DRAW_COUNT = 3

  HAND_UP_LIMIT = 10

  class NotEnoughFeeError < StandardError; end

  def initialize(name, max_health, turn_energy, draw_count, deck_built, statuses = {})
    @name = name
    @max_health = max_health
    @health = @max_health
    @turn_energy = turn_energy
    @energy = @turn_energy
    @block = INIT_BLOCK
    @draw_count = draw_count

    @decks = {
      built: deck_built,
      unused: [],
      hand: [],
      used: [],
      exhausted: [],
    }
    @decks[:built].each { |c| c.assign_owner!(self) }

    @statuses = statuses
  end

  def new_combat!(combat, team)
    @combat = combat
    @team = team
    cloned_built = @decks[:built].shuffle.map { |c| c.clone }
    @decks[:unused] = cloned_built
    @decks[:hand] = []
    @decks[:used] = []
    @decks[:exhausted] = []
  end

  def new_turn!
    # init
    @is_block_expire = true
    @can_draw_this_turn = true

    @statuses.each do |status_class, status|
      status.new_turn_act!
    end

    @block = 0 if @is_block_expire
    @energy = @turn_energy

    draw_cards!(count: @draw_count)
  end

  def end_turn!
    @statuses.each do |status_class, status|
      status.end_turn_act!
    end

    discard_cards!(count: @decks[:hand].size)
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

  def get_damage!(damage:, attacker:, args:)
    before_damage = damage
    damage = status_pipeline(
      pipe_type: :in,
      damage: before_damage,
      block: 0,
      fee: 0,
      args: args.merge(attacker: attacker)
    )[:damage]

    if @block > damage
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

  def get_block!(block:)
    @block += block
    puts "#{name} 护甲增加 #{block}"
  end

  def get_energy!(energy:)
    @energy += energy
    puts "#{name} 能量增加 #{energy}"
  end

  def get_health!(health:)
    @health += health
    puts "#{name} 生命增加 #{health}"
  end

  def make_damage(damage:, args:)
    before_damage = damage
    damage = status_pipeline(
      pipe_type: :out,
      damage: before_damage,
      block: 0,
      fee: 0,
      args: args
    )[:damage]

    damage = 0 if damage < 0

    damage
  end

  def draw_cards!(count:)
    return unless @can_draw_this_turn

    while count > 0 do
      draw_a_card!
      count -= 1
    end
  end

  def draw_a_card!
    if @decks[:unused].empty?
      if @decks[:used].empty?
        puts '卡池已空，无牌可抽'
        return
      end

      @decks[:unused] = @decks[:used].shuffle
      @decks[:used] = []
    end

    @decks[:hand] << @decks[:unused].pop
    @statuses.each do |status_class, status|
      status.draw_a_card!
    end
  end

  def draw_the_card!(card_key:, deck_type:)
    deck_type = deck_type.to_sym
    card = $card_pool[card_key].clone
    card.assign_owner!(self)
    @decks[deck_type] << card

    @statuses.each do |status_class, status|
      status.draw_a_card!
    end if deck_type == :hand
  end

  def status_pipeline(pipe_type:, damage:, block:, fee:, args:)
    piped_damage = damage
    piped_block = block
    piped_fee = fee
    @statuses.each do |status_class, status|
      piped_data = status.public_send(
        "#{pipe_type}_pipe!",
        damage: piped_damage,
        block: piped_block,
        fee: piped_fee,
        args: args
      )
      piped_damage = piped_data[:damage]
      piped_block = piped_data[:block]
      piped_fee = piped_data[:fee]
    end

    {
      damage: piped_damage,
      block: piped_block,
      fee: piped_fee
    }
  end

  def play_the_card!(deck_type, card_index)
    raise NotEnoughFeeError unless has_energy?(@decks[deck_type][card_index].fee)

    card = @decks[deck_type].delete_at(card_index)
    @energy -= card.fee
    card.act!
    if card.exhaust
      @decks[:exhausted] << card
    else
      @decks[:used] << card
    end
    @statuses.each do |status_class, status|
      status.play_a_card!
    end
  end

  def discard_cards!(count:)
    while count > 0 && @decks[:hand].size > 0 do
      @decks[:used] << @decks[:hand].delete_at(0)
      count -= 1
    end
  end

  def update_status!(status_class, count, hung_card = nil)
    if @statuses[status_class]
      @statuses[status_class].change_count!(
        change: count,
        hung_card: hung_card
      )
    else
      @statuses[status_class] = status_class.new(
        owner: self,
        count: count,
        hung_card: hung_card
      )
    end
  end

  def cancel_status!(status)
    @statuses.delete(status)
  end

  def player_info
    "Player #{@name}\n血量: #{@health}/#{@max_health} | 能量: #{@energy} | 护甲: #{@block} | 手牌数: #{@decks[:hand].count}"
  end

  def deck_info(deck_type)
    @decks[deck_type.to_sym].map.with_index do |card, i|
      "#{i + 1}) #{card.info}"
    end
  end

  def statuses_info
    @statuses.map do |status_class, status|
      "#{status_class.name}: #{status.count}"
    end
  end

  class << self
    def load_player(name)
      player_data = YAML.load(File.read("./data/players/#{name}_player.yaml"))

      player_data = player_data[player_data.keys[0]]
      deck_built = player_data['deck_built'].map do |card_key, count|
        count.times.map { $card_pool[card_key].clone }
      end.flatten
      Creacard::Player.new(
        player_data['name'],
        player_data['max_health'],
        player_data['turn_energy'],
        player_data['draw_count'],
        deck_built
      )
    end
  end
end
