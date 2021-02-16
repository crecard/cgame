class Creacard::WeakAttribute < Creacard::Attribute
  def description
    "增加 #{@value} 点 #{Creacard::WeakStatus.name}"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].update_status!(Creacard::WeakStatus, @value, nil)
    end
  end
end
