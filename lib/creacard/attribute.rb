class Creacard::Attribute
  TARGET_RANGES = [
    :all,
    :single,
  ]

  attr_reader :target_range, :target, :value

  class WrongTargetRangeError < StandardError; end

  def initialize(target_range:, target:, value:)
    @target_range = target_range.to_sym
    raise WrongTargetRangeError unless TARGET_RANGES.include?(@target_range)
    @target = target.to_s
    @value = value.to_i
  end

  class << self
    def load_attributes(attributes_data)
      attributes_data.map do |attr|
        attr_name = attr.keys[0]
        Object.const_get("Creacard::#{attr_name.capitalize}Attribute").new(
          target_range: attr[attr_name]['target_range'],
          target: attr[attr_name]['target'],
          value: attr[attr_name]['value']
        )
      end
    end
  end
end
