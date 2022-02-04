module Fiora::Commands
  module Info
    module Avatar 
      extend Discordrb::Commands::CommandContainer
      command(:avatar, aliases: [:pfp, :profilepicture]) do |event,id| 
        server = event.server
        author = event.author
        if id == nil
          member = event.author
        else
          member = Fiora::FioraUtility::fetch_member(id,server) 
          if member == nil
            event.respond("This ID isn't valid")
          end
        end
        
        if member != nil
          avatar_url = member.avatar_url
          event.send_embed do |embed| 
            embed.author = {name: author.username, icon_url: author.avatar_url}
            embed.title = member.username + "#" + member.discriminator + "'s avatar"
            embed.image = {url: member.avatar_url + "?size=4096"}
            embed.footer = {text: server.name, icon_url: server.icon_url}
            embed.color = Fiora::FioraUtility::dominant_color(member.avatar_url)
            embed.timestamp = Time.new
          end
        end
      end
    end
  end
end