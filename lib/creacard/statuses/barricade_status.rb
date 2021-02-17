class Creacard::BarricadeStatus < Creacard::Status
  def new_turn_act!
    @owner.is_block_expire = false
  end

  class << self
    def name
      'Barricade'
    end

    def description
      'Block no longer expires at the start of your turn.'
    end
  end
end
