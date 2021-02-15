class Creacard::VulnerableAttribute < Creacard::Attribute
  def description
    "增加 #{@value} 点 #{Creacard::VulnerableStatus.name}"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].update_status!(Creacard::VulnerableStatus, @value, nil)
    end
  end
end
