class Creacard::VulnerableAttribute < Creacard::Attribute
  def description
    "增加 #{value} 点 #{Creacard::VulnerableStatus.name}"
  end

  def act!(targets:)
    targets.each do |t|
      t.update_status!(Creacard::VulnerableStatus, value, nil)
    end
  end
end
