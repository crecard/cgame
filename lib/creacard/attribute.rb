class Creacard::Attribute
  TARGET_RANGES = [
    :all,
    :single,
  ]

  VALUE_TYPES = [
    :int,
    :variable
  ]

  attr_reader :target_range, :target, :value_type, :value

  class WrongTargetRangeError < StandardError; end
  class WrongValueTypeError < StandardError; end

  def initialize(target_range:, target:, value_type:, value:)
    @target_range = target_range.to_sym
    raise WrongTargetRangeError unless TARGET_RANGES.include?(@target_range)

    @value_type = value_type || :int
    @value_type = @value_type.to_sym
    raise WrongValueTypeError unless VALUE_TYPES.include?(@value_type)
    case @value_type
    when :int
      @value = value.to_i
    when :variable
      @value = value.to_s
    end

    @target = target.to_s
  end

  def value(owner)
    return @value if @value_type == :int

    case @value
    when 'block'
      owner.block
    end
  end

  class << self
    def load_attributes(attributes_data)
      attributes_data.map do |attr|
        attr_name = attr.keys[0]
        attr_data = attr[attr_name]
        Object.const_get("Creacard::#{attr_name.capitalize}Attribute").new(
          target_range: attr_data['target_range'],
          target: attr_data['target'],
          value_type: attr_data['value_type'],
          value: attr_data['value']
        )
      end
    end
  end
end
