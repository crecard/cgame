class Creacard::FlameBarrierStatus < Creacard::Status
  def in_pipe!(damage:, block:, fee:, args:)
    attacker = args[:attacker]
    attacker.get_damage!(
      damage: @count,
      attacker: nil,
      args: { status: self }
    ) if attacker

    super
  end

  def new_turn_act!
    cancel!
  end

  class << self
    def name
      'Flame Barrier'
    end

    def description
      "Whenever you are attacked this turn, deal #{@count} damage to the attacker."
    end
  end
end
