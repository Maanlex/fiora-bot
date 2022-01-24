module Fiora::Commands
  module Moderation
    module Clear
      extend Discordrb::Commands::CommandContainer
      command(:clear, aliases: [:prune]) do |event,nb| 
        channel = event.channel
        nb = nb.to_i
        author = event.author
        isAMod = author.roles.find {|role| role.name == '_mod'} != nil; 
        if isAMod 
          if nb != nil and nb <= 100 and nb >= 2
            channel.prune(1) 
            channel.prune(nb)
          else
            event.send_message("Must be a value between 2 and 100.")
          end
        else 
          event.send_message("You cannot do this, you aren't a moderator.")
        end
        return nil
      end
    end
  end
end