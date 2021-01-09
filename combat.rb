ROLE_NUM = 2
SIDE_NUM = 2
HAND_CARD_NUM = 4

class Combat
  attr_accessor :roles
  attr_reader :turn_num, :role_num

  def initialize(role_num = ROLE_NUM)
    @role_num = role_num
    @role_num.times do |i|
      @roles[i % SIDE_NUM][i / SIDE_NUM] = Role.new
    end
    @turn_num = 0
  end

  def combat_init
    deal
  end

  def who_win?
    win_side = -1
    SIDE_NUM.each do |i|
      side_is_live = @roles[i].inject(false) { |all, r| all || r.is_live? }
      if side_is_live
        return -1 unless win_side == -1 # more than one side are live

        win_side = i
      end
    end

    win_side
  end

  # 发牌
#  def deal
    #@role_num.times do |i|
      #cards = HAND_CARD_NUM.map { cards_pool.sample }
      #role_by_index[i].cards = cards
    #end
  #end

  def role_by_index(index)
    @roles[index % SIDE_NUM][i / SIDE_NUM]
  end
end
