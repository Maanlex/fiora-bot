require 'discordrb'
require 'yaml'
CONFIG = YAML.load_file('../config/config.yaml')

bot = Discordrb::Commands::CommandBot.new token: CONFIG['token'] , prefix: CONFIG['prefix']

bot.command :userinfo do |event, user|
  puts event.author.username
  #bot.send_message(event.channel,"")
end

at_exit { bot.stop }
bot.run