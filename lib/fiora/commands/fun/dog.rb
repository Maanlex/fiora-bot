module Fiora::Commands
  module Fun
    module Dog 
      extend Discordrb::Commands::CommandContainer
      include HTTParty
      BASE_URI = 'https://dog.ceo/api/breeds'

      command(:dog) do |event|
        author = event.author
        server = event.server

        res = HTTParty.get(BASE_URI + '/image/random')
        res_hash = JSON.parse(res.body, symbolize_names: true)
        event.send_embed do |embed|
          embed.author = {name: author.name, icon_url: author.avatar_url}
          embed.title = "A Random Dog"
          embed.image = {url: res_hash[:message]}
          embed.footer = {text: server.name, icon_url: server.icon_url}
          embed.timestamp = Time.new
        end
      end
    end
  end
end