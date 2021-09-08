class Unranked

  def self.add(uuid)
    if opponent = REDIS.spop("q")
      Game.start(uuid, opponent)
    else
      REDIS.sadd("q", uuid)
    end
    Game.broadcast_info
  end

  def self.add_room(uuid, code)
    if opponent = REDIS.getdel("room_#{code}") and code == REDIS.getdel("pcode_#{opponent}")
      Game.start(uuid, opponent)
    else
      REDIS.set("room_#{code}", uuid)
      REDIS.set("pcode_#{uuid}", code)
    end
  end

  def self.remove(uuid)
    REDIS.srem("q", uuid)
    if code = REDIS.getdel("pcode_#{uuid}")
      REDIS.del("room_#{code}")
    end
    Game.broadcast_info
  end

  def self.has_player
    REDIS.smembers("q").size > 0
  end

  def self.clear_all
    REDIS.del("q")
      
    Game.broadcast_info
  end
end
