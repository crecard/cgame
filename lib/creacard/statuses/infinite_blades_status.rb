class Creacard::InfiniteBladesStatus < Creacard::Status
  def new_turn_act!
    @owner.draw_the_card!(
      card_key: 'shiv',
      deck_type: :hand
    )
  end

  class << self
    def name
      'Infinite Blades'
    end

    def description
      'At the start of your turn, add a Shiv to your hand.'
    end
  end
end
