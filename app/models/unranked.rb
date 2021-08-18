class Unranked

  def self.add(uuid)
    if opponent = REDIS.spop("q")
      Game.start(uuid, opponent)
    else
      REDIS.sadd("q", uuid)
    end
  end

  def self.remove(uuid)
    REDIS.srem("q", uuid)
  end

  def self.has_player
    REDIS.smembers("q").size > 0
  end

  def self.clear_all
    REDIS.del("q")
  end
end
