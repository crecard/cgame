class Creacard::HealthAttribute < Creacard::Attribute
  def description
    "增加 #{@value} 点生命"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].get_health!(energy: value(owner))
    end
  end
end
