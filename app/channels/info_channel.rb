class InfoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "info"
    Players.add_player
  end

  def unsubscribed
    Players.remove_player
  end
end
