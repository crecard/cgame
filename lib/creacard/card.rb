require 'yaml'

class Creacard::Card
  attr_reader :name, :fee, :targets, :attributes

  def initialize(name, fee, targets, attributes)
    @name = name
    @fee = fee
    @targets = targets
    @attributes = attributes
  end

  def act(owner, combat)
    target_choosed = {}
    @attributes.each do |attr|
      unless target_choosed[attr.target]

      end
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
