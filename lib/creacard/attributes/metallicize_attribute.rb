class Creacard::MetallicizeAttribute < Creacard::Attribute
  def description
    "At the end of your turn, gain #{value} Block"
  end

  def act!(targets:)
    targets.each do |t|
      t.update_status!(Creacard::MetallicizeStatus, value)
    end
  end
end
