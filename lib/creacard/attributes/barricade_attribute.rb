class Creacard::BarricadeAttribute < Creacard::Attribute
  def description
    'Block no longer expires at the start of your turn'
  end

  def act!(targets:)
    targets.each do |t|
      update_status!(Creacard::BarricadeStatus, @value)
    end
  end
end
