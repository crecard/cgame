class Creacard::DamageAttribute < Creacard::Attribute

  def description
    "造成 #{@value} 点伤害"
  end

  def act!(owner:, targets: [])
    damage = owner.make_damage(damage: value(owner))

    case @target_range
    when :single
      targets[0].get_damage!(
        damage: damage,
        attacker: owner
      )
    end
  end
end
