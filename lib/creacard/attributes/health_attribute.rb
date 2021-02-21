class Creacard::HealthAttribute < Creacard::Attribute
  def description
    "增加 #{value} 点生命"
  end

  def act!(targets:)
    targets.each do |t|
      t.get_health!(health: value)
    end
  end
end
