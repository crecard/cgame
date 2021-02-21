class Creacard::Status
  PIPE_TYPE = [
    :in,
    :out
  ]

  attr_reader :owner, :combat, :count, :hung_cards

  def initialize(owner:, count:, hung_card:)
    @owner = owner
    @combat = owner.combat
    @count = count
    @hung_cards = [hung_card].compact
  end

  def change_count!(change:, hung_card: nil)
    @count += change.to_i
    @hung_cards << hung_card if hung_card

    cancel! if @count <= 0
  end

  def cancel!
    @owner.cancel_status!(self.class)
    #TODO: return hung cards
  end

  def out_pipe!(damage:, block:, fee:, args:)
    {
      damage: damage,
      block: block,
      fee: fee
    }
  end

  def in_pipe!(damage:, block:, fee:, args:)
    {
      damage: damage,
      block: block,
      fee: fee
    }
  end

  def new_turn_act!
  end

  def end_turn_act!
  end

  def draw_a_cards!
  end
end
