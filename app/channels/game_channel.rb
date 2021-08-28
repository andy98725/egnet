class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def queue_unranked
    Unranked.add(uuid)
  end

  def send_action(data)
      Game.send_action(uuid, data)
  end

  def quit_game
    Unranked.remove(uuid)
    Game.quit_game(uuid)
  end


  def unsubscribed
    quit_game
  end
end
