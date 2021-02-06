require 'yaml'

class Creacard::Card
  attr_reader :name, :fee, :discarded, :targets, :attributes

  def initialize(name, fee, targets, attributes)
    @name = name
    @fee = fee
    @targets = targets
    @attributes = attributes
  end

  def act!(owner, combat)
    target_choosed = {}
    @attributes.each do |attr|
      unless target_choosed[attr.target]
        target = choose_target(@targets[attr.target], owner, combat)
        target_choosed[attr.target] = target
      end

      attr.act!(players: [target_choosed[attr.target]])
    end
  end

  def choose_target(target_type, owner, combat)
    combat.public_send("choose_the_#{target_type}".to_sym, owner)
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
          data['targets'],
          attributes
        )
      end

      cards
    end
  end
end
