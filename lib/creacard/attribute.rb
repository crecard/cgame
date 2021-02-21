class Creacard::Attribute
  VALUE_TYPES = [
    :int,
    :variable
  ]

  attr_reader :target_range, :target, :value_type, :value
  attr_reader :owner, :combat

  class WrongValueTypeError < StandardError; end

  def initialize(target:, value_type:, value:)
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
  end

  def assign_owner!(owner)
    @owner = owner
  end

  def value
    return @value if @value_type == :int

    case @value
    when 'block'
      @owner ? @owner.block : 0
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
          value: attr_data['value']
        )
      end
    end
  end
end
