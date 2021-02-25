require 'yaml'

class Creacard::Card
  attr_reader :key, :name, :fee, :exhaust, :targets, :attributes
  attr_reader :owner, :combat

  TARGET_RANGES = [
    :all,
    :single,
  ]

  def initialize(key, name, fee, exhaust, targets, attributes)
    @key = key
    @name = name
    @fee = fee
    @exhaust = exhaust
    @targets = targets
    @attributes = attributes
  end

  def assign_owner!(owner)
    @owner = owner
    attributes.each do |attr|
      attr.assign_card!(self)
    end
  end

  def act!
    @combat = owner.combat
    targets_choosed = []
    @attributes.each do |attr|
      unless targets_choosed[attr.target]
        target_attr = @targets[attr.target]
        targets = @combat.public_send(
          "choose_the_#{target_attr['side']}".to_sym,
          @owner,
          target_attr['range']
        )
        targets_choosed[attr.target] = targets
      end

      attr.act!(targets: targets_choosed[attr.target])
    end
  end

  def description
    "#{@attributes.map(&:description).join('，')}。"
  end

  def info
    <<~INFO
#{@name} 费用: #{@fee}
#{description}
    INFO
  end

  class << self
    def load_all_cards(path)
      files = Dir.glob('**/*.yaml', base: path)
      card_data = files.map do |f|
        d = YAML.load(File.read(File.join(path, f)))
      end

      cards = card_data.map do |c|
        key = c.keys[0]
        data = c[key]
        attributes = Creacard::Attribute.load_attributes(data['attributes'])
        Creacard::Card.new(
          key,
          data['name'],
          data['fee'],
          data['exhaust'],
          data['targets'],
          attributes
        )
      end

      cards.to_h { |c| [c.key, c] }
    end
  end
end
