INIT_HEALTH = 100
INIT_ENERGY = 3
INIT_BLOCK = 0

class Player
  attr_accessor :health, :energy, :block
  attr_accessor :decks

  def initialize(health = INIT_HEALTH, energy = INIT_ENERGY, block = INIT_BLOCK)
    @health = health
    @energy = energy
    @block = block

    @decks = {
      built: [],
      unused: [],
      hand: [],
      discarded: [],
      depleted: []
    }
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
end
