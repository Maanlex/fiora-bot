module Fiora::Commands
  module Fun
    module Cat 
      extend Discordrb::Commands::CommandContainer
      
      include HTTParty
      BASE_URI = 'https://api.thecatapi.com/v1'
      TOKEN = Fiora::CONFIG['cat_api_token']

      pages = []

      command(:cat) do |event, option, nb|
        author = event.author
        server = event.server
        nb_pages = 0
        res_hash = {}

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

          # List all the breeds with their id
          if option == 'breeds' 
            if pages.empty?
              list = []
              fields = []

              res = HTTParty.get(BASE_URI + '/breeds', :headers => {"x-api-key" => TOKEN})
              res_hash = JSON.parse(res.body, symbolize_names: true)
              res_hash.each do |cat|
                list << cat[:name] + " (`" + cat[:id] + "`)"
              end

              nb_pages = (list.size / 15.0).ceil
              nb_pages.times do |i|
                embedPage = Discordrb::Webhooks::Embed.new
                embedPage.author = Discordrb::Webhooks::EmbedAuthor.new(
                  name: author.name, 
                  icon_url: author.avatar_url)
                
                embedPage.footer = Discordrb::Webhooks::EmbedFooter.new(
                  text: "Page " + (i+1).to_s + "/" + nb_pages.to_s,
                  icon_url: server.icon_url)
                
                embedPage.timestamp = Time.new

                lines = ""
                15.times do
                  if !list.empty?
                    lines << list[0] + "\n" 
                    list.shift
                  end
                end

                fields[i] = Discordrb::Webhooks::EmbedField.new(name: "List of all the breeds and their id :", value: lines, inline: false)
                embedPage.fields = [fields[i]]
                pages << embedPage
              end
            end
            
            nb = 1 if nb == nil
            embed = pages[nb.to_i-1]

          # Cat with a specified breed
          else
            res = HTTParty.get(BASE_URI + '/images/search?breed_ids=' + option, :headers => {"x-api-key" => TOKEN})
            res_hash = JSON.parse(res.body, symbolize_names: true)[0]
            
            if res_hash.class != NilClass
              embed.title = "A " + res_hash[:breeds][0][:name] + " Cat"
              embed.image = Discordrb::Webhooks::EmbedImage.new(url: res_hash[:url])
              #event.send_embed(nil,embed)
            else 
              event.respond("Please enter a valid breed id or `f!cat breeds` to list all the breeds available")
            end
          end
        end
        event.send_embed(nil,embed)
      end
    end
  end
end