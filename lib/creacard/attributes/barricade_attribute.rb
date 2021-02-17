class Creacard::BarricadeAttribute < Creacard::Attribute
  def description
    'Block no longer expires at the start of your turn'
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].update_status!(Creacard::BarricadeStatus, @value)
    end
  end
end
