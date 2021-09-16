class Unranked

  def self.add(uuid, name)
    REDIS.set("name_#{uuid}", name)
    if opponent = REDIS.spop("q")
      Game.start(uuid, opponent)
    else
      REDIS.sadd("q", uuid)
      DiscordBot.broadcast_looking name
    end
    Players.broadcast_info
  end

  def self.add_room(uuid, code, name)
    REDIS.set("name_#{uuid}", name)
    if opponent = REDIS.getdel("room_#{code}") and code == REDIS.getdel("pcode_#{opponent}")
      Game.start(uuid, opponent)
    else
      REDIS.set("room_#{code}", uuid)
      REDIS.set("pcode_#{uuid}", code)
    end
  end

  def self.remove(uuid)
    REDIS.del("name_#{uuid}")
    if REDIS.srem("q", uuid)
      DiscordBot.clear_searching
    end
    if code = REDIS.getdel("pcode_#{uuid}")
      REDIS.del("room_#{code}")
    end
    Players.broadcast_info
  end

  def self.has_player
    REDIS.smembers("q").size > 0
  end

  def self.clear_all
    REDIS.del("q")
    Players.broadcast_info
  end
end
