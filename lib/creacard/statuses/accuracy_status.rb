class Creacard::AccuracyStatus < Creacard::Status
  def out_pipe!(damage:, block:, fee:, args:)
    if args[:card] && args[:card].key == 'shiv'
      {
        damage: damage + @count,
        block: block,
        fee: fee
      }
    else
      super
    end
  end


  class << self
    def name
      'Accuracy'
    end

    def description
      'Shivs deal 4(6) additional damage.'
    end
  end
end
