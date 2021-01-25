require 'yaml'

class Creacard::Card
  attr_reader :name, :fee, :attributes

  def initialize(name, fee, attributes)
    @name = name
    @fee = fee
    @attributes = attributes
  end

  def attack(target)
    owner.energy -= fee
    target.get_damage(damage)
  end

  def description
    "#{@attributes.map(&:description).join('，')}。"
  end

  def info
    <<~INFO
费用: #{@fee}
#{description}
    INFO
  end

  class << self
    def load_cards(path)
      files = Dir.glob('**/*.yaml', base: path)
      card_data = files.map do |f|
        d = YAML.load(File.read(File.join(path, f)))
      end

      cards = card_data.map do |c|
        data = c[c.keys[0]]
        attributes = Creacard::Attribute.load_attributes(data['attributes'])
        Creacard::Card.new(
          data['name'],
          data['fee'],
          attributes
        )
      end

      cards
    end
  end
end

class Creacard::StrikeCard < Creacard::Card
  @@fee = 1
  @@damage = 5

  attr_reader :name

  def initialize
    @name = '攻击'
  end

  def fee
    @@fee
  end

  def damage
    @@damage
  end

  def description
    "伤害 #{damage}"
  end

  def use(combat, owner, target)
    return -1 unless owner.has_energy?(self.fee)

    attack(target)
  end
end
