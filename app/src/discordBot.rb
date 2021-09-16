
require 'discordrb'

ID_server = 494724898439036938
ID_admin_user = 143468067031089152
ID_online_channel = 887447044036362290
ID_role_message = 887809411303735376
ID_active_role = 800083761906974730
ID_online_role = 887448939010326528
ID_red_role = 887776922149486612
ID_blue_role = 887776975060619274


class DiscordBot
  def self.run
    self.join
    @bot.run
  end
  def self.join
    return if @bot
    @bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
    @branch = ENV['BASE_WARS_BRANCH'] # 'beta' or 'stable'
    Rails.logger.info "ENV VARS #{ENV.keys}!!! !!! !!!"
    Rails.logger.info "BRANCH #{ENV['BASE_WARS_BRANCH']}"
    Rails.logger.info "VAR #{@branch}"

    @bot.ready do |event|
      @OnlineRole = @bot.servers[ID_server].role(ID_online_role)

      Rails.logger.info "Discord Bot Online."
    end

    if @branch == 'stable'

      @bot.reaction_add do |event|
        break unless event.message.id == ID_role_message
        case event.emoji.to_reaction
        when "fight:887765729607299082"
          event.user.add_role(ID_active_role)
        when "online:887765766714306630"
          event.user.add_role(ID_online_role)
        when "🟥"
          Rails.logger.info "Blue #{event.user.role?(ID_blue_role)}"
          event.user.add_role(ID_red_role) #unless event.user.role?(ID_blue_role)
        when "🟦"
          event.user.add_role(ID_blue_role) #unless event.user.role?(ID_red_role)
        else
          event.message.delete_reaction(event.user, event.emoji.to_reaction)
        end
      end
      @bot.reaction_remove do |event|
        break unless event.message.id == ID_role_message
        case event.emoji.to_reaction
        when "fight:887765729607299082"
          event.user.remove_role(ID_active_role)
        when "online:887765766714306630"
          event.user.remove_role(ID_online_role)
        when "🟥"
          event.user.remove_role(ID_red_role)
        when "🟦"
          event.user.remove_role(ID_blue_role)
        end
      end

      @bot.message(content: "!copy", from: ID_admin_user) do |event|
        original = event.channel.history(1, event.message.id)[0]
        copy = event.respond original.content
        original.reactions.each do |reaction|
          copy.react(reaction.to_s)
        end
      end
      @bot.message(content: "!stop", from: ID_admin_user) do |event|
        bot.send_message(event.channel.id, 'Bot is shutting down')
        exit
      end
      
      Funnies.each do |message, response|
        @bot.message(content: message) do |event|
          event.respond response
        end
      end

    end
  end

  def self.broadcast_looking name
    Rails.logger.info "On branch #{@branch}"
    return if !@branch
    self.join
    self.clear_searching

    append = @branch == 'stable'? "! #{@OnlineRole.mention}" : ' on the BETA server!'
    @searching = @bot.send_message(ID_online_channel, "#{name} is looking for a game#{append}")
  end
  def self.broadcast_game name, name2
    return if !@branch
    self.join
    self.clear_searching
    @bot.send_message(ID_online_channel, "Game started: #{name} VS #{name2}")
  end

  def self.clear_searching
    if @searching
      @searching.delete
      @searching = nil
    end
  end
end


Funnies = [["Ping!", "Pong!"],
          ["Who lives in a pineapple under the sea?", "Spongebob Squarepants!"],
          ["This... is...", "SPARTA!!!"],
          ["Who da bes?", "You da bes :D"],
          ["War Bot sucks!", ":("],
          ["9+10", "21"]]