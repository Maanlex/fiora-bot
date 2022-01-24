module Fiora::Commands
  module Moderation
    module AddMod
      extend Discordrb::Commands::CommandContainer
      command(:addMod) do |event,id|
        if event.author == event.server.owner 
          newMod = Fiora::FioraUtility::fetch_member(id,event.server).on(server)
          if newMod == nil
            event.respond("This ID isn't valid")
          end
          to_add = newMod.server.roles.find {|role| role.name == '_mod'}
          if to_add == nil
            to_add = newMod.server.create_role(name: "_mod", mentionable: false, permissions: 17209368710) 
          end
          newMod.add_role(to_add)
          event.respond(newMod.mentions + "is now a Moderator on this server !")
        else
          event.respond("You cannot do this, you aren't the owner")
        end
      end
    end
  end
end