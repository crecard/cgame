class Creacard::AThousandCutsStatus < Creacard::Status
  def play_a_card!(card:)
    enemies = @combat.choose_the_enemy(@owner, 'all')
    enemies.each do |e|
      e.get_damage!(
        damage: 1,
        attacker: nil,
        args: { status: self }
      )
    end
  end

  class << self
    def name
      'A Thousand Cuts'
    end

    def description
      "Whenever you play a card, deal 1 damage to ALL enemies."
    end
  end
end
