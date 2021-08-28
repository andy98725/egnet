class Game
  
  def self.add_player
    REDIS.INCRBY("online", 1)
    self.broadcast_info
  end
  def self.remove_player
    REDIS.INCRBY("online", -1)
    self.broadcast_info
  end

  def self.broadcast_info
    ActionCable.server.broadcast "info",
        {action: "server_info", "players": REDIS.GET("online"),
        "unranked_player": Unranked.has_player}
  end

  def self.start(id1, id2)
    p1, p2 = [id1, id2].shuffle

    REDIS.SET("opponent_for:#{p1}", p2)
    REDIS.SET("opponent_for:#{p2}", p1)

    ActionCable.server.broadcast "player_#{p2}", {"action": "server_start", "info": "client"}
    ActionCable.server.broadcast "player_#{p1}", {"action": "server_start", "info": "host"}
  end

  def self.quit_game(uuid)
    opponent = REDIS.GETDEL("opponent_for:#{uuid}")
    return if opponent.blank?

    ActionCable.server.broadcast "player_#{opponent}", {"action": "client_disconnect"}
    REDIS.DEL("opponent_for:#{opponent}")
  end


  def self.send_action(uuid, info)
    opponent = REDIS.get("opponent_for:#{uuid}")
    return if opponent.blank?

    ActionCable.server.broadcast "player_#{opponent}", {"action": "client_action", "info": info["data"]}
  end

end