# frozen_string_literal: true

REDIS = Redis.new(
  url:  ENV['REDIS_URL'],
  port: ENV['REDIS_PORT'],
  db:   ENV['REDIS_DB'])

  
REDIS.SET("online", 0)
