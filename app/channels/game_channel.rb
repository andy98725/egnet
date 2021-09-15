class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def queue_unranked(data)
    Unranked.add(uuid, JSON.parse(data['data'])['name'])
  end

  def queue_room(data)
    #TODO add client
    Unranked.add_room(uuid, JSON.parse(data['data'])['code'],JSON.parse(data['data'])['name'])
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
