class Creacard::BlockAttribute < Creacard::Attribute
  def description
    "增加 #{value} 点护甲"
  end

  def act!(targets:)
    targets.each do |t|
      t.get_block!(block: value)
    end
  end
end
