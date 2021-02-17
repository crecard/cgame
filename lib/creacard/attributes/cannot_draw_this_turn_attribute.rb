class Creacard::CannotDrawThisTurnAttribute < Creacard::Attribute
  def description
    'You cannot draw additional cards this turn'
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].can_draw_this_turn = false
    end
  end
end
