class Creacard::Controller
  attr_reader :combat

  COMMANDS = %w(
    h help
    cb combat
    hd hand_deck
    ds decks
    cd card
    e end
    exit
  )

  def initialize(combat)
    @combat = combat
  end

  def begin!
    while true do
      cmd, arg = get_root_cmd

      public_send("cmd_#{cmd}", arg)
    end
  end

  def get_root_cmd
    puts '>>>> Please input the h for help'
    while true do
      current_player = combat.current_player
      print("#{current_player.name}, input your command> ")
      input = gets.split(' ')
      cmd, arg = input[0], input[1]
      return cmd, arg if COMMANDS.include?(cmd)
    end
  end

  def cmd_help(_)
    puts <<~INFO
h, help: 帮助信息
cb, combat: 查看当前战场
hd, hand_deck: 查看和使用手牌
ds, decks + type: 查看牌堆，built - 构筑，unused 未使用牌，hand 手牌，used 使用，discarded 废弃
e, end: 结束当前回合
exit: 结束游戏
    INFO
  end
  alias_method :cmd_h, :cmd_help

  def cmd_combat(_)
    puts @combat.info
  end
  alias_method :cmd_cb, :cmd_combat

  def cmd_hand_deck(_)
    @combat.choose_the_card_to_use!
  end
  alias_method :cmd_hd, :cmd_hand_deck

  def cmd_decks(deck_type)
    deck_type = deck_type.to_s.to_sym
    current_player = @combat.current_player
    unless current_player.decks.keys.include?(deck_type)
      puts 'Wrong arguments'
      return
    end
    puts current_player.deck_info(deck_type)
  end
  alias_method :cmd_ds, :cmd_decks

  def cmd_end(_)
    @combat.current_player.end_turn!
    combat.next_player!
  end
  alias_method :cmd_e, :cmd_end

  def cmd_exit(_)
    exit
  end
end
