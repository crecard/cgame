class Creacard::DrawCardAttribute < Creacard::Attribute
  def description
    "抽 #{value} 张卡牌"
  end

  def act!(targets:)
    targets.each do |t|
      if @args['card_key'] && @args['deck_type']
        value.times do
          t.draw_the_card!(
            card_key: @args['card_key'],
            deck_type: @args['deck_type'].to_sym
          )
        end
      else
        t.draw_cards!(count: value)
      end
    end
  end
end
