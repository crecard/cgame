class Creacard::CannotDrawThisTurnAttribute < Creacard::Attribute
  def description
    'You cannot draw additional cards this turn'
  end

  def act!(targets:)
    targets.each do |t|
      t.can_draw_this_turn = false
    end
  end
end
