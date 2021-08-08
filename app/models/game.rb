class Game
  def self.start(id1, id2)
    p1, p2 = [id1, id2].shuffle

    ActionCable.server.broadcast "player_#{p1}", {action: "game_start", msg: "host"}
    ActionCable.server.broadcast "player_#{p2}", {action: "game_start", msg: "client"}

    REDIS.set("opponent_for:#{p1}", p2)
    REDIS.set("opponent_for:#{p2}", p1)

  end

  def self.opponent_for(uuid)
    return REDIS.get("opponent_for:#{uuid}")
  end

  def self.send_info(uuid, info)
    opponent = opponent_for(uuid)

    # "player_#{opponent}"
    ActionCable.server.broadcast "player_#{uuid}", {"action": "get_info", "info": info["data"]}
  end

end