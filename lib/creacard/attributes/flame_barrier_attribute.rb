class Creacard::FlameBarrierAttribute < Creacard::Attribute
  def description
    "Whenever you are attacked this turn, deal #{@value} damage to the attacker"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].update_status!(Creacard::FlameBarrierStatus, @value)
    end
  end
end
