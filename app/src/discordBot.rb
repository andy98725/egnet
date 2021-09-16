
require 'discordrb'

ID_server ||= 494724898439036938
ID_admin_user ||= 143468067031089152
ID_online_channel ||= 887447044036362290
ID_role_message ||= 887809411303735376
ID_active_role ||= 800083761906974730
ID_online_role ||= 887448939010326528
ID_red_role ||= 887776922149486612
ID_blue_role ||= 887776975060619274

class DiscordBot
  def self.run
    puts "Initializing Discord Bot..."

    $discordBot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']

    $discordBot.ready do |event|
      $online_role = $discordBot.servers[ID_server].role(ID_online_role)
      Rails.logger.info "Discord Bot Online."
      puts "Discord Bot Online."
    end

    if ENV['BASE_WARS_BRANCH'] == 'stable'
      $discordBot.reaction_add do |event|
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
      $discordBot.reaction_remove do |event|
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

      $discordBot.message(content: "!copy", from: ID_admin_user) do |event|
        original = event.channel.history(1, event.message.id)[0]
        copy = event.respond original.content
        original.reactions.each do |reaction|
          copy.react(reaction.to_s)
        end
      end
      $discordBot.message(content: "!stop", from: ID_admin_user) do |event|
        bot.send_message(event.channel.id, 'Bot is shutting down')
        exit
      end
      
      Funnies.each do |message, response|
        $discordBot.message(content: message) do |event|
          event.respond response
        end
      end
    end
    $discordBot.run(true)
  end

  def self.broadcast_looking name
    if self.should_send_messages
      self.clear_searching
      @searching = $discordBot.send_message(ID_online_channel, "#{name} is looking for a game#{self.append_msg}") 
    end
  end
  def self.append_msg
    if ENV['BASE_WARS_BRANCH'] == 'stable'
      "! #{$online_role.mention}"
    elsif ENV['BASE_WARS_BRANCH'] == 'beta'
      " on the BETA server!"
    else
      " on the TEST server!"
    end
  end
  def self.broadcast_game name, name2
    if self.should_send_messages
      self.clear_searching
      $discordBot.send_message(ID_online_channel, "Game started: #{name} VS #{name2}")
    end
  end

  def self.should_send_messages
    case ENV['BASE_WARS_BRANCH'] 
    when 'stable'
      true
    when 'beta'
      true
    when 'test'
      false
    else
      false
    end
  end

  def self.clear_searching
    if @searching
      @searching.delete
      @searching = nil
    end
  end
end


Funnies ||= [["Ping!", "Pong!"],
          ["Who lives in a pineapple under the sea?", "Spongebob Squarepants!"],
          ["This... is...", "SPARTA!!!"],
          ["Who da bes?", "You da bes :D"],
          ["War Bot sucks!", ":("],
          ["9+10", "21"]]