module Fiora::Commands
  module Moderation
    module Kick 
      extend Discordrb::Commands::CommandContainer
      command(:kick) do |event, id, *reason|
        author = event.author
        server = author.server

        isAMod = author.roles.find {|role| role.name == '_mod'} != nil; 
        if isAMod
          if id == nil
            event.send_message("You need to specify a member to kick.")
          else
            member = Fiora::FioraUtility::fetch_member(id,event.server)
            if member.bot_account
              event.send_message("You cannot kick a bot.")
              return nil
            end
            reason == [] ? reason = "Unspecified" : reason = reason.join

            event.send_embed do |embed|
              embed.author = {name: server.name, icon_url: server.icon_url}
              embed.title = "KICK"
              embed.thumbnail = {url: member.avatar_url}
              embed.add_field name: "Member kicked:", value: "<@" + member.id.to_s + ">", inline: true
              embed.add_field name: "By:", value: "<@" + author.id.to_s + ">", inline: true
              embed.add_field name: "Reason:", value: reason, inline: true
            end
            server.kick(member)
          end
        else 
          event.send_message("You cannot do this, you aren't a moderator.")
        end

      end
    end
  end
end