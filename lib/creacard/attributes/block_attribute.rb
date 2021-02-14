class Creacard::BlockAttribute < Creacard::Attribute

  def description
    "增加 #{@value} 点护甲"
  end

  def act!(players: [])
    case @target_range
    when :single
      players[0].get_block!(block: @value)
    end
  end
end
