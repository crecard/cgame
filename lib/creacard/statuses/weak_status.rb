class Creacard::WeakStatus < Creacard::Status
  def out_pipe!(damage:, block:, fee:)
    {
      damage: (damage.to_i * 0.75).floor,
      block: block,
      fee: fee
    }
  end

  def end_turn_act!
    change_count!(change: -1)
  end

  class << self
    def name
      '虚弱'
    end

    def description
      'Weak creatures deal 25% less damage with Attacks.'
    end
  end
end
