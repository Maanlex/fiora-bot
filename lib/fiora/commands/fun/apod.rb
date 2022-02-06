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

        embedImage = Discordrb::Webhooks::Embed.new
        embedImage.author = Discordrb::Webhooks::EmbedAuthor.new(name: author.name, icon_url: author.avatar_url)
        embedImage.title = res_hash[:title]
        embedImage.image = Discordrb::Webhooks::EmbedImage.new(url: res_hash[:hdurl])
        embedImage.footer = Discordrb::Webhooks::EmbedFooter.new(text: server.name, icon_url: server.icon_url)
        embedImage.timestamp = Time.new

        embedDescription = Discordrb::Webhooks::Embed.new
        embedDescription.author = Discordrb::Webhooks::EmbedAuthor.new(name: author.name, icon_url: author.avatar_url)
        embedDescription.title = res_hash[:title]
        embedDescription.description = res_hash[:explanation]
        embedDescription.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: res_hash[:hdurl])
        embedDescription.footer = Discordrb::Webhooks::EmbedFooter.new(text: server.name, icon_url: server.icon_url)
        embedDescription.timestamp = Time.new

        event.send_embed(nil,embedImage) do |_,view|
          view.row do |r|
            r.button(label: 'See Description', style: :primary, custom_id: 'button_see_description')
          end
        end

        event.send_embed(nil,embedDescription) do |_,view|
          view.row do |r|
            r.button(label: 'Go Back', style: :primary, custom_id: 'button_see_image')
          end
        end
        
      end

      Fiora::BOT.button(custom_id: 'button_see_description') do |event|
        event.update_message(embed: embedDescription)
      end

      Fiora::BOT.button(custom_id: 'button_see_image') do |event|
        event.update_message(embed: embedImage)
      end
    end
  end
end