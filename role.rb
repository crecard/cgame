MAX_HEALTH = 10
MAX_FEE = 10

class Role
  attr_accessor :health, :fee
  attr_accessor :hand_cards

  def initialize(health = MAX_HEALTH, fee = MAX_FEE)
    @health = health
    @fee = fee
    @hand_cards = []
  end

  def is_dead?
    @health <= 0
  end

  def has_fee?
    @fee > 0
  end
end
