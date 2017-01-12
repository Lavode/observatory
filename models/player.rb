class Player < Sequel::Model
  def self.from_player_data(data)
    player = Player.where(account_id: data.steam_id).first
    if player.nil?
      # Create new player if needed.
      player = Player.create(
        hive2_player_id: data.player_id,
        account_id:      data.steam_id,
        reinforced_tier: data.reinforced_tier
      )
    end

    # Add new data point based on current data.
    player_data = PlayerData.build_from_player_data(data, player_id: player.id)
    player.update(current_player_data: player_data)

    player
  end

  plugin :validation_helpers
  def validate
    validates_presence [:account_id, :hive2_player_id]
  end

  one_to_many :player_data,         class: :PlayerData
  many_to_one :current_player_data, class: :PlayerData, key: :current_player_data_id

  def adagrad_sum
    return nil unless current_player_data
    current_player_data.adagrad_sum
  end

  def alias
    return nil unless current_player_data
    current_player_data.alias
  end

  def experience
    return nil unless current_player_data
    current_player_data.experience
  end

  def level
    return nil unless current_player_data
    current_player_data.level
  end

  def score
    return nil unless current_player_data
    current_player_data.score
  end

  def skill
    return nil unless current_player_data
    current_player_data.skill
  end

  def time_total
    return nil unless current_player_data
    current_player_data.time_total
  end

  def time_alien
    return nil unless current_player_data
    current_player_data.time_alien
  end

  def time_marine
    return nil unless current_player_data
    current_player_data.time_marine
  end

  def time_commander
    return nil unless current_player_data
    current_player_data.time_commander
  end

  def update_data(stalker: nil)
    stalker ||= HiveStalker::Stalker.new

    begin
      data = stalker.get_player_data(account_id)
      player_data = PlayerData.build_from_player_data(data, player_id: id)
      update(current_player_data: player_data)

      true
    rescue HiveStalker::APIError
      false
    end
  end

  # Retrieves recent distinct player data.  That is, if two entries are equal
  # (which is determined by whether total playtime changed), only the newest
  # will be returned.
  #
  # @param count [Fixnum] Number of entries which to return at most. `nil` in
  #   order to not limit entries.
  # @return [Array<PlayerData>]
  def recent_player_data(count = nil)
    out = []
    last_data = nil

    player_data_dataset.order_by(Sequel.desc(:created_at)).each do |data|
      if count && out.size >= count
        return out
      end

      if last_data.nil? || last_data.time_total != data.time_total
        out << data
      end
      last_data = data
    end

    out
  end

#   def graph_time_played_total
#     {
#       'Alien': time_alien,
#       'Marine': time_marine
#     }
#   end
# 
#   def graph_time_played
#     [
#       {
#         name: 'Alien',
#         data: player_data.map { |data| [data.created_at, data.time_alien] }
#       },
#       {
#         name: 'Marine',
#         data: player_data.map { |data| [data.created_at, data.time_marine] }
#       },
#     ]
#   end
# 
#   def graph_skill
#     player_data.map do |data|
#       [data.created_at, data.skill]
#     end
#   end
# 
#   def graph_experience_level
#     [
#       {
#         name: 'Experience',
#         data: player_data.map { |data| [data.created_at, data.experience] }
#       },
#       {
#         name: 'Level',
#         data: player_data.map { |data| [data.created_at, data.level] }
#       },
#     ]
#   end
end
