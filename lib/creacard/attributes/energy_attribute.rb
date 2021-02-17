class Creacard::EnergyAttribute < Creacard::Attribute
  def description
    "增加 #{@value} 点能量"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].get_energy!(energy: value(owner))
    end
  end
end
