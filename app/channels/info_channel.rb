class InfoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "info"
    Game.add_player
  end

  def unsubscribed
    Game.remove_player
  end
end
