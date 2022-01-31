module Fiora::Commands
  module Fun
    module Cat 
      extend Discordrb::Commands::CommandContainer
      
      include HTTParty
      BASE_URI = 'https://api.thecatapi.com/v1'
      TOKEN = Fiora::CONFIG['cat_api_token']

      nb_pages = 0
      cur_page = 0
      pages = []
      message = nil

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

          # List all the breeds with their id
          if option == 'breeds' 
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
                text: server.name,
                icon_url: server.icon_url)
              
              embedPage.timestamp = Time.new

              str = ""
              15.times do
                if !list.empty?
                  str << list[0] + "\n" 
                  list.shift
                end
              end
              fields[i] = Discordrb::Webhooks::EmbedField.new(name: "List of all the breeds and their id :", value: str, inline: false)
              embedPage.fields = [fields[i]]
              pages << embedPage
            end

            event.send_embed(nil,pages[0]) do |_, view|
              view.row do |r|
                r.button(label: 'Previous Page', style: :primary, emoji: '⬅️', custom_id: 'previous_page_cat_button')
                r.button(label: 'Next Page', style: :primary, emoji: '➡️', custom_id: 'next_page_cat_button')
              end
            end

          # Cat with a specified breed
          else
            res = HTTParty.get(BASE_URI + '/images/search?breed_ids=' + option, :headers => {"x-api-key" => TOKEN})
            res_hash = JSON.parse(res.body, symbolize_names: true)[0]
            
            if res_hash.class != NilClass
              embed.title = "A " + res_hash[:breeds][0][:name] + " Cat"
              embed.image = Discordrb::Webhooks::EmbedImage.new(url: res_hash[:url])
              event.send_embed(nil,embed)
            else 
              event.respond("Please enter a valid breed id or `f!cat breeds` to list all the breeds available")
            end
          end
        end
      end

      Fiora::BOT.button(custom_id: 'next_page_cat_button') do |event|
        cur_page = (cur_page + 1) % nb_pages
        event.update_message(embeds: [pages[cur_page]]) do |_, view|
          view.row do |r|
            r.button(label: 'Previous Page', style: :primary, emoji: '⬅️', custom_id: 'previous_page_cat_button')
            r.button(label: 'Next Page', style: :primary, emoji: '➡️', custom_id: 'next_page_cat_button')
          end
        end
      end

      Fiora::BOT.button(custom_id: 'previous_page_cat_button') do |event|
        cur_page = (cur_page - 1) % nb_pages
        event.update_message(embeds: [pages[cur_page]]) do |_, view|
          view.row do |r|
            r.button(label: 'Previous Page', style: :primary, emoji: '⬅️', custom_id: 'previous_page_cat_button')
            r.button(label: 'Next Page', style: :primary, emoji: '➡️', custom_id: 'next_page_cat_button')
          end
        end
      end
    end
  end
end