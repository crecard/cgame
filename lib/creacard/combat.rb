class Creacard::Combat
  attr_accessor :teams
  attr_reader :turn_num

  def initialize(teams)
    @teams = teams

    @turn_num = 0
  end

  def begin
    teams.each do |team|
      team.each { |p| p.new_combat(self, team) }
    end
  end

  def info
    puts "回合数: #{@turn_num}"
    teams.each_with_index do |team, i|
      puts "======= Team #{i} ========="
      team.each_with_index do |player, j|
        puts "======== Player #{j} ========"
        player.player_info
        player.deck_info(:built)
        puts ' '
      end
    end
  end

  # return :not_end, :draw, :index_of_winner
  def who_is_winner?
    teams_dead = teams.map { |t| team_is_dead?(t) }

    return :draw if teams_dead.uniq == [true]
    return :not_end if teams_dead.count { |d| d == false } > 1

    teams_dead.index(false)
  end

  def new_turn
    queue = []
    teams.map(&:size).max.times do |player_index|
      teams.each do |current_team|
        @current_player = current_team[player_index]
        next unless @current_player

        puts @current_player.player_info(Creacard::Player::VIEW_TYPES_PRIVATE)
        choose_the_card_to_use!
      end
    end
  end

  def choose_the_card_to_use!
    puts @current_player.deck_info(:hand)
    while true
      print('Choose the card to use: ')
      choose = gets.to_i - 1

      if choose >= 0 && choose < @current_player.decks[:hand].size
        begin
          @current_player.use_the_card!(:hand, choose)
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
        puts "#{enemy_index += 1}: #{enemy.player_info(Creacard::Player::VIEW_TYPES_PUBLIC)}"
      end
    end
    while true do
      print('Choose the enemy to attack: ')
      choose = gets.to_i - 1

      return enemies[choose] if choose >= 0 && choose < enemy_index
      puts 'Wrong choose, try again'
    end
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
