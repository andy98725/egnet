class Players
  
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
end