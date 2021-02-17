class Creacard::VulnerableStatus < Creacard::Status
  def in_pipe!(damage:, block:, fee:)
    {
      damage: (damage.to_i * 1.5).floor,
      block: block,
      fee: fee
    }
  end

  def end_turn_act!
    change_count!(change: -1)
  end

  class << self
    def name
      '易伤'
    end

    def description
      'Take 50% more damage from Attacks.'
    end
  end
end
