Module Fiora::Events
  Module ChannelCreate 
    extend Discordrb::EventContainer

    channel_create do |event|
      
      # Update permissions for the muted role
      muted_role = server.roles.find {|role| role.name == '_muted_'}
      if event.type == 1 && muted_role != nil
        deny = Discordrb::Permissions.new
        deny.can_send_messages = true
        event.channel.define_overwrite(to_add,0,deny)
      end
    end
  end
end
