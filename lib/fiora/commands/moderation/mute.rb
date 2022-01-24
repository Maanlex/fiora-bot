module Fiora::Commands
  module Moderation
    module Mute 
      extend Discordrb::Commands::CommandContainer
      command(:mute) do |event,id,*reason|
        author = event.author
        server = author.server

        isAMod = author.roles.find {|role| role.name == '_mod'} != nil; 
        if isAMod

          if id == nil
            event.send_message("You need to specify a member to mute.")
          else
            to_add = server.roles.find {|role| role.name == '_muted_'}

            if to_add == nil # If the muted role doesn't exist yet
              to_add = server.create_role(name: "_muted_", mentionable: false, permissions: 0)
              deny = Discordrb::Permissions.new
              deny.can_send_messages = true
              server.channels.each { |channel| channel.define_overwrite(to_add,0,deny)}
            end

            member = Fiora::FioraUtility::fetch_member(id,event.server)
            if member.bot_account
              event.send_message("You cannot mute a bot.")
              return nil
            end

            if member.roles.find {|role| role.name == '_muted_'} != nil
              event.send_message("This member is already muted.")
              return nil
            end

            reason == [] ? reason = "Unspecified" : reason = reason.join

            event.send_embed do |embed|
              embed.author = {name: server.name, icon_url: server.icon_url}
              embed.title = "MUTE"
              embed.thumbnail = {url: member.avatar_url}
              embed.add_field name: "Member muted:", value: member.mention, inline: true
              embed.add_field name: "By:", value: author.mention, inline: true
              embed.add_field name: "Reason:", value: reason, inline: true
              embed.footer = {text: server.name, icon_url: server.icon_url}
              embed.timestamp = Time.new
            end
            member.add_role(to_add)
          end
        else 
          event.send_message("You cannot do this, you aren't a moderator.")
        end
      end
    end
  end
end