class Creacard::BlockAttribute < Creacard::Attribute

  def description
    "增加 #{@value} 点护甲"
  end

  def act!(owner:, targets: [])
    case @target_range
    when :single
      targets[0].get_block!(block: value(owner))
    end
  end
end
