module Fiora::Commands
  module Info
    module UserInfo
      extend Discordrb::Commands::CommandContainer
  
      command(:userinfo, aliases: [:ui, :whois, :user]) do |event, id|
        server = event.server
        author = event.author
        if id == nil
          member = event.author
        else
          member = Fiora::FioraUtility::fetch_member(id,server)
          if  member == nil
            event.respond("This ID isn't valid")
          end
        end
        
        
        if member != nil
          # Construction of the embed to send
          event.send_embed do |embed|
            embed.author = { name: author.name, icon_url: author.avatar_url }
            embed.thumbnail = { url: member.avatar_url}
            embed.color = Fiora::FioraUtility::dominant_color(member.avatar_url)
            embed.title = "User Information | " + member.username + "#" + member.discriminator
            embed.description = "Currently " + member.status.to_s.capitalize
            embed.add_field name: "Nickname:", value: member.display_name, inline: true
            embed.add_field name: "ID:", value: member.id, inline: true
            embed.add_field name: "\u200b", value: "────────────────", inline: false
            embed.add_field name: "Created Account On:", value: member.creation_time, inline: true
            embed.add_field name: "Joined This Server On", value: member.joined_at, inline: true
            embed.add_field name: "\u200b", value: "────────────────", inline: false
            roles = member.roles.map { |role| role.name != "@everyone" ? role.mention : role.name }.join(", ")
            embed.add_field name: "Roles:", value: roles, inline: false
            embed.footer = {text: server.name, icon_url: server.icon_url}
            embed.timestamp = Time.new
          end
        end
      end
    end
  end
end