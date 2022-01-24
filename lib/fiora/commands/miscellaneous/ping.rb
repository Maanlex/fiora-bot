module Fiora::Commands
  module Miscellaneous
    module Ping 
      extend Discordrb::Commands::CommandContainer
      command(:ping) do |event|
        event.respond(Fiora::BOT.name)
      end
    end
  end
end