class GameChannel < ApplicationCable::Channel
  def subscribed
    logger.info "subscribed"
    stream_from "game_channel"

  end

  def my_method(data)
    puts data
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
