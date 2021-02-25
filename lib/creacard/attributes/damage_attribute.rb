class Creacard::DamageAttribute < Creacard::Attribute

  def description
    "造成 #{value} 点伤害"
  end

  def act!(targets:)
    damage = @owner.make_damage(
      damage: value,
      args: { card: card }
    )

    targets.each do |t|
      t.get_damage!(
        damage: damage,
        attacker: @owner,
        args: { card: card }
      )
    end
  end
end
