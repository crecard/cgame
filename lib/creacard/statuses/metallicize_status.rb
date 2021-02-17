class Creacard::MetallicizeStatus < Creacard::Status
  def end_turn_act!
    @owner.get_block!(block: count)
  end

  class << self
    def name
      'Metallicize'
    end

    def description
      'At the end of your turn, gain 3(4) Block.'
    end
  end
end
