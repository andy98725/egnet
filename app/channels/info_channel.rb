class InfoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "info_#{uuid}"
    Game.add_player

    update
  end

  def update
    Game.broadcast_info(uuid)
  end

  def unsubscribed
    Game.remove_player
  end
end
