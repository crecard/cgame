class Creacard::Card
  def attack(target)
    owner.energy -= fee
    target.get_damage(damage)
  end

  def info
    puts "费用: #{fee} | 伤害: #{damage}"
    puts "#{description}"
  end
end

class Creacard::StrikeCard < Creacard::Card
  @@fee = 1
  @@damage = 5

  attr_reader :name

  def initialize
    @name = '攻击'
  end

  def fee
    @@fee
  end

  def damage
    @@damage
  end

  def description
    "伤害 #{damage}"
  end

  def use(combat, owner, target)
    return -1 unless owner.has_energy?(self.fee)

    attack(target)
  end
end
