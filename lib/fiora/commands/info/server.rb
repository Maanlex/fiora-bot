module Fiora::Commands
  module Info
    module ServerInfo
      extend Discordrb::Commands::CommandContainer

      command(:serverinfo, aliases: [:si, :server]) do |event|
        author = event.author
        server = author.server
        event.send_embed do |embed|
          embed.author = {name: author.username, icon_url: author.avatar_url}
          embed.description = "Currently " + server.online_members.size.to_s + " members online"
          embed.thumbnail = {url: server.icon_url}
          embed.title = "Server information | " + server.name
          embed.add_field name: "Owner:", value: server.owner.mention, inline: true
          embed.add_field name: "ID:", value: server.id, inline: true
          embed.add_field name: "Server created:", value: server.creation_time, inline: true
          embed.add_field name: "Members:", value: server.member_count, inline: true
          embed.add_field name: "Role count:", value: server.roles.size, inline: true
          embed.add_field name: "Emoji count:", value: server.emoji.size, inline: true
          embed.add_field name: "\u200b", value: "────────────────", inline: false
          roles = server.roles.map { |role| role.name != "@everyone" ? role.mention : role.name }.join(", ")
          embed.add_field name: "All roles:", value: roles, inline: false
          embed.add_field name: "\u200b", value: "────────────────", inline: false
          emoji = ""
          server.emoji.each_value{ |v| emoji = emoji + v.mention + "  " }
          embed.add_field name: "All emotes:", value: emoji, inline: false
          embed.footer = {text: server.name, icon_url: server.icon_url}
          embed.timestamp = Time.new
        end
      end
    end
  end
end 