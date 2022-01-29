module Fiora
  module FioraUtility
    
    # Return a Member from a server with the id of the User
    def self.fetch_member(id,server)
      id.delete!('<@!').delete!(">") if id.include?("<")
      res = server.members.select { |member| member.id == id.to_i }
      return nil if res.empty?
      return res[0]
    end
  end
end