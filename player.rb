MAX_HEALTH = 10
MAX_ENERGY = 10

class Player
  attr_accessor :health, :energy, :block
  attr_accessor :hand_deck

  def initialize(health = MAX_HEALTH, energy = MAX_ENERGY)
    @health = health
    @energy = energy
    @block = 0
    @hand_deck = []
  end

  def is_dead?
    @health <= 0
  end

  def is_live?
    !is_dead?
  end

  def has_energy?(fee = 1)
    @fee >= fee
  end

  def get_damage(damage)
    if block >= damage
      block -= damage
      return
    end

    damage -= block
    block = 0
    health -= damage
  end
end
