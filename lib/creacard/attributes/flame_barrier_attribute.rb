class Creacard::FlameBarrierAttribute < Creacard::Attribute
  def description
    "Whenever you are attacked this turn, deal #{value} damage to the attacker"
  end

  def act!(targets:)
    targets.each do |t|
      t.update_status!(Creacard::FlameBarrierStatus, value)
    end
  end
end
