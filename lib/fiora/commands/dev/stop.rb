module Fiora::Commands
  module Dev
    module Stop
      extend Discordrb::Commands::CommandContainer
      command(:stop, aliases: [:s, :q, :quit]) do |event|
        if(event.author.id == 368029105595351042)
          event.respond("Stopping Fiora...")
          Fiora::BOT.stop
        end
      end
    end
  end
end