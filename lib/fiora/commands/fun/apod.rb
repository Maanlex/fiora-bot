module Fiora::Commands
  module Fun
    module Apod 
      extend Discordrb::Commands::CommandContainer
      include HTTParty

      command(:apod) do |event|
        author = event.author
        server = event.server

        res = HTTParty.get("https://api.nasa.gov/planetary/apod?api_key=" + Fiora::CONFIG['nasa_api_token'])
        res_hash = JSON.parse(res.body,symbolize_names: true)
        puts res_hash

        embedImage = Discordrb::Webhooks::Embed.new
        embedImage.author = name: author.name, icon_url: author.avatar_url}
        embedImage.title = res_hash[:title]
        embedImage.image = {url: res_hash[:hdurl]}
        embedImage.footer = {text: server.name, icon_url: server.icon_url}
        embedImage.timestamp = Time.new
        
      end
    end
  end
end