class Creacard::Combat
  attr_accessor :teams
  attr_reader :turn_num, :current_player, :current_team_index, :current_player_index

  def initialize(teams)
    @teams = teams
  end

  def begin!
    @teams.each do |team|
      team.each { |p| p.new_combat!(self, team) }
    end

    @turn_num = 1
    @current_team_index = 0
    @current_player_index = 0
    @current_player = @teams[@current_team_index][@current_player_index]
    system('clear')
    @current_player.new_turn!
  end

  def info
    puts "回合数: #{@turn_num}"
    teams.each_with_index do |team, i|
      puts "======= Team #{i + 1} ========="
      team.each_with_index do |player, j|
        puts player.player_info
        puts player.statuses_info
        puts "\n"
      end
    end

    nil
  end

  # return :not_end, :draw, :index_of_winner
  def who_is_winner?
    teams_dead = teams.map { |t| team_is_dead?(t) }

    return :draw if teams_dead.uniq == [true]
    return :not_end if teams_dead.count { |d| d == false } > 1

    teams_dead.index(false)
  end

  def check_winner!
    winner = who_is_winner?
    case winner
    when :draw
      puts "==== 平局还是 bug？ ===="
      exit
    when :not_end
      return
    else
      puts "!!!! Team #{winner} is winner! ===="
      exit
    end
  end

  def next_player!
    if @current_player_index + 1 >= @teams[@current_team_index].size
      if @current_team_index + 1 >= @teams.size
        @turn_num += 1
        @current_team_index = 0
        @current_player_index = 0
      else
        @current_team_index += 1
        @current_player_index = 0
      end
    else
      @current_player_index += 1
    end

    @current_player = @teams[@current_team_index][@current_player_index]
    @current_player.new_turn!
  end

  def choose_the_card_to_use!
    puts @current_player.deck_info(:hand)
    while true
      print('Choose the card to use: ')
      choose = gets.strip
      return if choose == 'exit'

      choose = choose.to_i - 1
      if choose >= 0 && choose < @current_player.decks[:hand].size
        begin
          @current_player.use_the_card!(:hand, choose)
          check_winner!

          return
        rescue Creacard::Player::NotEnoughFeeError
          puts 'Not enough fee'
        end
      else
        puts 'Wrong choose, try again'
      end
    end
  end

  def choose_the_enemy(owner)
    enemy_teams = teams.reject { |t| t == owner.team }
    enemy_index = 0
    enemies = []
    enemy_teams.each.with_index do |enemy_team, enemy_team_index|
      puts "==== Team #{enemy_team_index}: #{enemy_team.size} Enemies ===="
      enemy_team.each do |enemy|
        enemies << enemy
        puts "#{enemy_index += 1}: #{enemy.player_info}"
      end
    end
    while true do
      print('Choose the enemy to attack: ')
      choose = gets.to_i - 1

      return enemies[choose] if choose >= 0 && choose < enemy_index
      puts 'Wrong choose, try again'
    end
  end

  def choose_the_myself(owner)
    owner
  end

  def choose_the_friend
  end

  private

  def team_is_dead?(team)
    team.each do |player|
      return true if player.is_dead?
    end

    false
  end
end
