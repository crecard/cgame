class Card
  def attack(target)
    owner.energy -= fee
    target.get_damage(damage)
  end
end

class StrikeCard < Card
  @@fee = 1
  @@damage = 5

  attr_accessor :owner

  def initialize(owner)
    @owner = owner
  end

  def fee
    @@fee
  end

  def damage
    @@damage
  end

  def use(combat, target)
    return -1 unless owner.has_energy?(self.fee)

    attack(target)
  end
end
