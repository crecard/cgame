class Creacard::DrawCardAttribute < Creacard::Attribute
  def description
    "抽 #{value} 张卡牌"
  end

  def act!(targets:)
    targets.each do |t|
      t.draw_cards!(count: value)
    end
  end
end
