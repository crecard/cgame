class Creacard::EnergyAttribute < Creacard::Attribute
  def description
    "增加 #{value} 点能量"
  end

  def act!(targets:)
    targets.each do |t|
      t.get_energy!(energy: value)
    end
  end
end
