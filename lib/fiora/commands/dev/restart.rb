module Fiora::Commands
  module Dev
    module Restart
      extend Discordrb::Commands::CommandContainer
      command(:rs, aliases: [:restart]) do |event|
        if(event.author.id == 368029105595351042)
          event.respond("Restarting Fiora...")
          Fiora::BOT.stop
          exec("bundle exec ruby run.rb")
        end
      end
    end
  end
end