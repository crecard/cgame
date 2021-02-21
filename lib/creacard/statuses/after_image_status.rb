class Creacard::AfterImageStatus < Creacard::Status
  def play_a_card!
    @owner.get_block!(block: 1)
  end

  class << self
    def name
      'After Image'
    end

    def description
      'Whenever you play a card, gain 1 Block.'
    end
  end
end
