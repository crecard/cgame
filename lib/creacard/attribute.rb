class Creacard::Attribute
  ACT_TARGET_TYPES = [
    :enemy_all,
    :enemy_single,
    :friend_all,
    :friend_single,
    :myself
  ]

  def need_targets
    raise 'Not defined'
  end

  def need_value
    raise 'Not defined'
  end

  def act
    raise 'Not defined'
  end

  class << self
    def load_attributes(attributes_data)
      attributes_data.map do |attr|
        attr_name = attr.keys[0]
        Object.const_get("Creacard::#{attr_name.capitalize}Attribute").new(
          target_type: attr[attr_name]['target_type'],
          target: attr[attr_name]['target'],
          value: attr[attr_name]['value']
        )
      end
    end
  end
end

class Creacard::DamageAttribute < Creacard::Attribute
  attr_reader :target_type, :target, :value

  def initialize(target_type:, target:, value:)
    @target_type = target_type
    @target = target
    @value = value
  end

  def description
    "造成 #{@value} 点伤害"
  end

  def act!(players: [])
    case @target_type
    when 'single'
      players[0].get_damage!(damage: @value)
    end
  end
end
