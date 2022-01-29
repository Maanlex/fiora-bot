module Fiora::Commands
  module Fun
    module Cat 
      extend Discordrb::Commands::CommandContainer
      
      include HTTParty
      BASE_URI = 'https://api.thecatapi.com/v1'
      TOKEN = Fiora::CONFIG['cat_api_token']

      command(:cat) do |event, option|
        author = event.author
        server = event.server

        embed = Discordrb::Webhooks::Embed.new
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(
          name: author.name, 
          icon_url: author.avatar_url)
        
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(
          text: server.name,
          icon_url: server.icon_url)
          
        embed.timestamp = Time.new

        # Random cat
        if(option == nil)
          res = HTTParty.get(BASE_URI + '/images/search?limit=1', :headers => {"x-api-key" => TOKEN})
          res_hash = JSON.parse(res.body, symbolize_names: true)[0]
          embed.title = "A Random Cat"
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: res_hash[:url])
          
        else
          case option
          when 'breeds'
            list = ""
            res = HTTParty.get(BASE_URI + '/breeds', :headers => {"x-api-key" => TOKEN})
            res_hash = JSON.parse(res.body, symbolize_names: true)
            res_hash.each do |cat|
              list << cat[:name] + "\n"
            end
            
            event.respond(list)
            
          end
        end

        
      end
    end
  end
end