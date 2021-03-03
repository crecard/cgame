class Creacard::Attribute
  VALUE_TYPES = [
    :int,
    :variable
  ]

  attr_reader :target, :value_type, :value, :args
  attr_reader :owner, :combat, :card

  class WrongValueTypeError < StandardError; end

  def initialize(target:, value_type:, value:, args:)
    @value_type = value_type || :int
    @value_type = @value_type.to_sym
    raise WrongValueTypeError unless VALUE_TYPES.include?(@value_type)
    case @value_type
    when :int
      @value = value.to_i
    when :variable
      @value = value.to_s
    end

    @target = target
    @args = args
  end

  def assign_card!(card)
    @card = card
    @owner = card.owner
  end

  def value
    return @value if @value_type == :int

    case @value
    when 'block'
      @owner ? @owner.block : 0
    when 'attack_card_played_this_turn'
      @owner ? @owner.attack_card_played_this_turn : 0
    end
  end

  def act!(targets:)
    @combat = @owner.combat
  end

  class << self
    def load_attributes(attributes_data)
      attributes_data.map do |attr|
        attr_name = attr.keys[0]
        attr_data = attr[attr_name]
        attr_class = attr_name.split('_').map(&:capitalize).join
        Object.const_get("Creacard::#{attr_class}Attribute").new(
          target: attr_data['target'],
          value_type: attr_data['value_type'],
          value: attr_data['value'],
          args: attr_data
        )
      end
    end
  end
end
