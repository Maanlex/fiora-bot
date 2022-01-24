module Fiora::Commands
  module Moderation
    module Unmute 
      extend Discordrb::Commands::CommandContainer

      command(:unmute) do |event,id|
        author = event.author
        server = author.server
        
        isAMod = author.roles.find {|role| role.name == '_mod'} != nil; 
        if isAMod

          if id == nil
            event.send_message("You need to specify a member to mute.")
          else
            
            member = Fiora::FioraUtility::fetch_member(id,event.server)
            if member.bot_account
              event.send_message("You cannot unmute a bot.")
              return nil
            end

            unmute = member.roles.find {|role| role.name == '_muted_'}
            if unmute == nil
              event.send_message("This member isn't muted.")
              return nil
            end

            event.send_embed do |embed|
              embed.author = {name: member.username + "#" + member.discriminator + " has been unmuted.", icon_url: server.icon_url}
            end
            member.remove_role(unmute)
          end
        else 
          event.send_message("You cannot do this, you aren't a moderator.")
        end
      end
    end
  end
end