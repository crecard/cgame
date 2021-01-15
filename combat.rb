class Combat
  attr_accessor :team_up, :team_down
  attr_reader :turn_num

  def initialize(team_up, team_down)
    @team_up = team_up
    @team_down = team_down

    @turn_num = 0
  end

  def begin
    team_up.each { |p| p.new_combat }
    team_down.each { |p| p.new_combat }
  end

  def info
    puts "回合数: #{@turn_num}"
    [team_up, team_down].each_with_index do |team, i|
      puts "======= Team #{i} ========="
      team.each_with_index do |player, j|
        puts "======== Player #{j} ========"
        player.info
        puts ' '
      end
    end
  end

  def who_win?
  end

  def role_by_index(index)
    @roles[index % SIDE_NUM][i / SIDE_NUM]
  end
end
