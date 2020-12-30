ROLE_NUM = 2
SIDE_NUM = 2
HAND_CARD_NUM = 4

class Game
  attr_accessor :roles
  attr_reader :cards_pool, :turn_num, :role_num

  def initialize(role_num = ROLE_NUM, cards_pool)
    @role_num = role_num
    @role_num.times do |i|
      @roles[i % SIDE_NUM][i / SIDE_NUM] = Role.new
    end
    @turn_num = 0
  end

  def game_init
    deal
  end

  # 发牌
  def deal
    @role_num.times do |i|
      cards = HAND_CARD_NUM.map { cards_pool.sample }
      role_by_index[i].cards = cards
    end
  end

  def role_by_index(index)
    @roles[index % SIDE_NUM][i / SIDE_NUM]
  end
end
