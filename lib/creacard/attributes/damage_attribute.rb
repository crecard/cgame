class Creacard::DamageAttribute < Creacard::Attribute

  def description
    "造成 #{@value} 点伤害"
  end

  def act!(players: [])
    case @target_range
    when :single
      players[0].get_damage!(damage: @value)
    end
  end
end
