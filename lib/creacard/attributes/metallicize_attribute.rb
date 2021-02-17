class Creacard::MetallicizeAttribute < Creacard::Attribute
  def description
    "At the end of your turn, gain #{@value} Block"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].update_status!(Creacard::MetallicizeStatus, @value)
    end
  end
end
