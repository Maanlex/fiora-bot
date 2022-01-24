module Fiora
  module FioraUtility
    def self.fetch_member(id,server)
      id.delete!('<@!').delete!(">") if id.include?("<")
      res = server.members.select { |member| member.id == id.to_i }
      return nil if res.empty?
      return res[0]
    end
  end
end