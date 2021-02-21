class Creacard::WeakAttribute < Creacard::Attribute
  def description
    "增加 #{value} 点 #{Creacard::WeakStatus.name}"
  end

  def act!(targets:)
    targets.each do |t|
      t.update_status!(Creacard::WeakStatus, value, nil)
    end
  end
end
