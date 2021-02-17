class Creacard::DrawCardAttribute < Creacard::Attribute
  def description
    "抽 #{@value} 张卡牌"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].draw_cards!(count: @value)
    end
  end
end
