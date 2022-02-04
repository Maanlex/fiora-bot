module Fiora
  module FioraUtility
    include MiniMagick

    # Return a Member from a server with the id of the User
    def self.fetch_member(id,server)
      id.delete!('<@!').delete!(">") if id.include?("<")
      res = server.members.select { |member| member.id == id.to_i }
      return nil if res.empty?
      return res[0]
    end

    # Return the dominant color of an image
    def self.dominant_color(image_path)
      image = MiniMagick::Image.open(image_path)
  
      # Get image histogram
      result = image.run_command('convert', image_path, '-format', '%c', '-colors', 1, '-depth', 8, 'histogram:info:')
      hex_value = result.scan(/(\#[0-9ABCDEF]{6,8})/).flatten
      return hex_value[0]
    end
  end
end