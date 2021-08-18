class UnrankedChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end
  def get_info

  end
  
  def queue_unranked
    Unranked.add(uuid)
  end

  def send_action(data)
      Game.send_action(uuid, data)
  end

  def unsubscribed
    Unranked.remove(uuid)
    # TODO disconnect during game edge cases
  end
end
