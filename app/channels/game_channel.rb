class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end
  
  def queue_unranked
    Unranked.add(uuid)
  end

  def send_info(data)
      Game.send_info(uuid, data)
  end

  def unsubscribed
    Unranked.remove(uuid)
    # TODO disconnect during game edge cases
  end
end
