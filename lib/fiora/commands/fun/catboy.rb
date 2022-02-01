module Fiora::Commands
  module Fun
    module Catboy
      extend Discordrb::Commands::CommandContainer
      include HTTParty

      command(:catboy) do |event|
        author = event.author
        server = event.server

        res = HTTParty.get("https://api.catboys.com/img")
        res_hash = JSON.parse(res.body,symbolize_names: true)
        
        event.send_embed do |embed|
          embed.author = {name: author.name, icon_url: author.avatar_url}
          embed.title = "A Random Catboy by " + res_hash[:artist]
          embed.image = {url: res_hash[:url]}
          embed.url = res_hash[:artist_url]
          embed.footer = {text: server.name, icon_url: server.icon_url}
          embed.timestamp = Time.new
        end
      end
    end
  end
end