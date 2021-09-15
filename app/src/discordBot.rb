
require 'discordrb'

ID_server = 494724898439036938
ID_admin_user = 143468067031089152
ID_online_channel = 887447044036362290
ID_online_role = 887448939010326528
ID_active_role = 800083761906974730


class DiscordBot
  def self.run
    self.join
    puts "Discord Bot Online."
    @bot.run
  end
  def self.join
    return if @bot
    @bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN']
    @branch = ENV['BASE_WARS_BRANCH'] # 'beta' or 'stable'

    if @branch == 'stable'
      @bot.message(content: "!notify", in: ID_online_channel) do |event|
        self.toggle_role event, ID_online_role, "Online"
      end
      @bot.message(content: "!active") do |event|
        self.toggle_role event, ID_active_role, "Active"
      end
      @bot.message(content: "!help") do |event|
        event.respond Help_message
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

  def self.toggle_role event, role_id, role_name
    if event.user.role?(role_id)
      event.user.remove_role(role_id)
      event.respond "Removed #{role_name} role from #{event.user.name}"
    else
      event.user.add_role(role_id)
      event.respond "Gave #{role_name} role to #{event.user.name}"
    end
  end

  def self.broadcast_looking name
    return if !@branch
    self.join
    self.clear_searching
    append = @branch == 'stable'? '! @Online' : ' on the BETA server!'
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
Help_message =
"**Commands**:
```
!active
```
This gives you the Active role, which anybody can ping for questions or finding a game.
If you no longer want this role, simply use the command again.
```
!notify
```
When done in #online-games, this gives you the Online role.
This role gets pinged any time someone is looking for a game in matchmaking."