class Creacard::Status
  attr_reader :owner, :count, :hung_cards

  def initialize(owner:, count:, hung_card:)
    @owner = owner
    @count = count
    @hung_cards = [hung_card].compact
  end

  def change_count!(change:, hung_card:)
    @count += change.to_i
    @hung_cards << hung_card if hung_card

    cancel! if @count <= 0
  end

  def cancel!
    owner.cancel_status!(self)
    #TODO: return hung cards
  end
end
